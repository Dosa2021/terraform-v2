# ---------------------------------------------
# ALB(追加)
# ---------------------------------------------
resource "aws_lb" "alb" {
  name               = "${var.environment}-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.web.id
  ]
  subnets = [
    aws_subnet.public.id,
    aws_subnet.public-c.id
  ]
}

# ---------------------------------------------
# listener(追加)
# ---------------------------------------------
resource "aws_lb_listener" "aws_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

# ---------------------------------------------
# target group(追加)
# ---------------------------------------------
resource "aws_lb_target_group" "alb_target_group" {
  name     = "${var.environment}-app-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-app-tg"
    Env  = var.environment
  }
}

resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.test-ec2.id
}
