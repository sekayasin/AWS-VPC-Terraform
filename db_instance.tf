resource "aws_instance" "db_instance" {
  ami           = "ami-0676a4fb6c9b2f72d"
  instance_type = "t2.micro"

  security_groups = ["${aws_security_group.database-sg.id}"]

  subnet_id = "${aws_subnet.database-private-sub.id}"

  private_ip = "172.30.1.10"

  key_name = "${aws_key_pair.mykeypair.key_name}"

  tags {
    Name = "db_instance"
  }
}
