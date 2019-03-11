resource "aws_instance" "api_instance" {
  ami           = "ami-08ea1edfbc412abfb"
  instance_type = "t2.micro"

  security_groups = ["${aws_security_group.api-sg.id}"]

  subnet_id = "${aws_subnet.backend-pub.id}"

  private_ip = "172.18.2.10"

  key_name = "${aws_key_pair.mykeypair.key_name}"

  tags {
    Name = "api_instance"
  }
}
