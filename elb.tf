data "aws_acm_certificate" "alb" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

# ---------------------------------------------
# ALB(追加)
# ---------------------------------------------
resource "aws_lb" "alb" {
  name               = "${var.environment}-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.elb.id
  ]
  subnets = [
    aws_subnet.public.id,
    aws_subnet.public-c.id
  ]

  # 作成: IGW / ルートが先。削除: ALB が先（IGW destroy のブロック防止）
  depends_on = [
    aws_internet_gateway.main,
    aws_route_table_association.public,
    aws_route_table_association.public-c,
  ]
}

# ---------------------------------------------
# listener(追加)
# ---------------------------------------------
resource "aws_lb_listener" "aws_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "aws_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  # certificate_arn   = "arn:aws:acm:ap-northeast-1:797964065122:certificate/a983bf43-ec7f-40b2-b860-964882a77cfa"
  certificate_arn = data.aws_acm_certificate.alb.arn
  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    # forward {
    #   stickiness {
    #     duration = 3600
    #     enabled  = false
    #   }
    #   target_group {
    #     arn    = "arn:aws:elasticloadbalancing:ap-northeast-1:797964065122:targetgroup/dev-app-tg/5bdb65bb4c6cebad"
    #     weight = 1
    #   }
    # }
    # default_action {
    #   type             = "forward"
    #   target_group_arn = aws_lb_target_group.alb_target_group.arn
    # }



  }
  # forward {
  #   stickiness {
  #     duration = 3600
  #     enabled  = false
  #   }
  #   target_group {
  #     arn    = "arn:aws:elasticloadbalancing:ap-northeast-1:797964065122:targetgroup/dev-app-tg/5bdb65bb4c6cebad"
  #     weight = 1
  #   }
  # }

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
  port             = 80
}
