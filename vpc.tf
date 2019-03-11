# app vpc
resource "aws_vpc" "main-global-vpc" {
  cidr_block           = "172.18.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "main-global-vpc"
  }
}

resource "aws_vpc" "main-local-vpc" {
  cidr_block           = "172.30.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags {
    Name = "main-local-vpc"
  }
}

# public subnet - frontend app
resource "aws_subnet" "frontend-pub" {
  vpc_id                  = "${aws_vpc.main-global-vpc.id}"
  cidr_block              = "172.18.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = "true"

  tags {
    Name = "frontend-pub"
  }
}

# public subnet - frontend app in a different zone
resource "aws_subnet" "frontend-pub-zone-b" {
  vpc_id                  = "${aws_vpc.main-global-vpc.id}"
  cidr_block              = "172.18.3.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = "true"

  tags {
    Name = "frontend-pub-zone-b"
  }
}

resource "aws_subnet" "backend-pub" {
  vpc_id                  = "${aws_vpc.main-global-vpc.id}"
  cidr_block              = "172.18.2.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = "true"

  tags {
    Name = "backend-pub"
  }
}

resource "aws_subnet" "database-private-sub" {
  vpc_id                  = "${aws_vpc.main-local-vpc.id}"
  cidr_block              = "172.30.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2a"

  tags {
    Name = "database-private-sub"
  }
}

resource "aws_subnet" "nat-pub" {
  vpc_id                  = "${aws_vpc.main-local-vpc.id}"
  cidr_block              = "172.30.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2a"

  tags {
    Name = "nat-pub"
  }
}

# Internet gateway
resource "aws_internet_gateway" "main-global-igw" {
  vpc_id = "${aws_vpc.main-global-vpc.id}"

  tags {
    Name = "main-global-igw"
  }
}

resource "aws_internet_gateway" "main-local-igw" {
  vpc_id = "${aws_vpc.main-local-vpc.id}"

  tags {
    Name = "main-local-igw"
  }
}

# route-tables
resource "aws_route_table" "main-global-rtb" {
  vpc_id = "${aws_vpc.main-global-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-global-igw.id}"
  }

  route {
    cidr_block                = "172.30.1.0/24"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.global-local-pcx.id}"
  }

  tags {
    Name = "main-global-rtb"
  }
}

resource "aws_route_table" "main-local-rtb" {
  vpc_id = "${aws_vpc.main-local-vpc.id}"

  route {
    cidr_block                = "172.18.2.0/24"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.global-local-pcx.id}"
  }

  route {
    cidr_block                = "172.18.1.0/24"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.global-local-pcx.id}"
  }

  route {
    cidr_block                = "172.18.3.0/24"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.global-local-pcx.id}"
  }

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat-instance.id}"
  }

  tags {
    Name = "main-local-rtb"
  }
}

resource "aws_route_table" "nat-rtb" {
  vpc_id = "${aws_vpc.main-local-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-local-igw.id}"
  }

  tags {
    Name = "nat-rtb"
  }
}

# subnet routetable associations with public subnets
resource "aws_route_table_association" "frontend-pub-assoc" {
  subnet_id      = "${aws_subnet.frontend-pub.id}"
  route_table_id = "${aws_route_table.main-global-rtb.id}"
}

resource "aws_route_table_association" "frontend-pub-zoneb-assoc" {
  subnet_id      = "${aws_subnet.frontend-pub-zone-b.id}"
  route_table_id = "${aws_route_table.main-global-rtb.id}"
}

resource "aws_route_table_association" "backend-pub-assoc" {
  subnet_id      = "${aws_subnet.backend-pub.id}"
  route_table_id = "${aws_route_table.main-global-rtb.id}"
}

# subnet route table associations with private subnets
resource "aws_route_table_association" "database-private-assoc" {
  subnet_id      = "${aws_subnet.database-private-sub.id}"
  route_table_id = "${aws_route_table.main-local-rtb.id}"
}

resource "aws_route_table_association" "nat-pub-assoc" {
  subnet_id      = "${aws_subnet.nat-pub.id}"
  route_table_id = "${aws_route_table.nat-rtb.id}"
}

# VPC Peering 
resource "aws_vpc_peering_connection" "global-local-pcx" {
  vpc_id      = "${aws_vpc.main-global-vpc.id}"
  peer_vpc_id = "${aws_vpc.main-local-vpc.id}"
  auto_accept = true

  tags {
    Name = "global-local-pcx"
  }
}
