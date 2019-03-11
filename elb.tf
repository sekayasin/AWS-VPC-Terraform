# Target group resources for use with Load Balancer resources
resource "aws_lb_target_group" "webapp_lb_target_group" {
  vpc_id      = "${aws_vpc.main-global-vpc.id}"
  name        = "webapp-lb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }

  tags = {
    Name = "webapp-lb-target-group"
  }
}

resource "aws_lb" "webapp_lb" {
  name               = "webapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.main-global-sg.id}"]
  subnets            = ["${aws_subnet.frontend-pub.id}", "${aws_subnet.frontend-pub-zone-b.id}"]

  tags = {
    Name = "webapp-lb"
  }
}

resource "aws_lb_listener" "webapp_lb_listener" {
  load_balancer_arn = "${aws_lb.webapp_lb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.webapp_lb_target_group.arn}"
    type             = "forward"
  }
}

#Register instance with an Application lb
resource "aws_lb_target_group_attachment" "webapp_lb_attach" {
  target_group_arn = "${aws_lb_target_group.webapp_lb_target_group.arn}"
  target_id        = "${aws_instance.frontend-app.id}"
  port             = 80
}
