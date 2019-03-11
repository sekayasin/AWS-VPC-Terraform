resource "aws_instance" "frontend-app" {
  ami             = "ami-03adc63cf814614dd"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.main-global-sg.id}"]
  key_name        = "${aws_key_pair.mykeypair.key_name}"

  subnet_id = "${aws_subnet.frontend-pub.id}"

  private_ip = "172.18.1.10"

  tags = {
    Name = "web-app-frontend"
  }
}

resource "aws_instance" "frontend-app-zoneb" {
  ami             = "ami-03adc63cf814614dd"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.main-global-sg.id}"]
  key_name        = "${aws_key_pair.mykeypair.key_name}"

  subnet_id = "${aws_subnet.frontend-pub-zone-b.id}"

  private_ip = "172.18.3.10"

  tags = {
    Name = "web-app-frontend-zone-b"
  }
}
