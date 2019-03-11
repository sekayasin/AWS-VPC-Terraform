resource "aws_instance" "nat-instance" {
  ami             = "ami-0ca65a55561666293"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.nat-instance.id}"]
  key_name        = "${aws_key_pair.mykeypair.key_name}"

  subnet_id = "${aws_subnet.nat-pub.id}"

  private_ip = "172.30.2.10"

  source_dest_check = false

  tags = {
    Name = "nat-instance"
  }
}
