resource "aws_lb" "reverse_proxy_alb" {
  name               = "reverse-proxy-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.reverse_proxy_1.id, aws_subnet.reverse_proxy_2.id]
  depends_on         = [aws_internet_gateway.gw]
}

resource "aws_lb_target_group" "reverse_proxy_tg" {
  name        = "reverse-proxy-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "reverse_proxy_listener" {
  load_balancer_arn = aws_lb.reverse_proxy_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.reverse_proxy_tg.arn
  }
}
