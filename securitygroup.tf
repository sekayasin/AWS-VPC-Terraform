resource "aws_security_group" "main-global-sg" {
  name        = "main-global-sg"
  description = "Allow ssh only to my ip, port 80 and all egress traffic"
  vpc_id      = "${aws_vpc.main-global-vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["154.70.157.171/32", "41.210.172.102/32", "105.21.72.66/32"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.30.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "main-global-sg"
  }
}

resource "aws_security_group" "api-sg" {
  name        = "api-sg"
  description = "Allow ssh only to my ip, port 8000 and all egress traffic"
  vpc_id      = "${aws_vpc.main-global-vpc.id}"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["154.70.157.171/32", "41.210.172.102/32", "105.21.72.66/32"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.30.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "api-sg"
  }
}

resource "aws_security_group" "database-sg" {
  name        = "database-sg"
  description = "All ssh only from our prem insider networks 172.30.0.0/16"
  vpc_id      = "${aws_vpc.main-local-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.30.0.0/16"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["172.18.1.0/24", "172.18.2.0/24"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nat-instance" {
  name        = "nat-instance"
  description = "Allow ssh only my home ip and office ips"
  vpc_id      = "${aws_vpc.main-local-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["154.70.157.171/32", "41.210.172.102/32", "105.21.72.66/32"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["172.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
