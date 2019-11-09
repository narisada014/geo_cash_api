resource "aws_lb" "geocache_alb" {
  name = "geocache-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.geocache_alb.id]
  subnets = aws_subnet.geocache_public_subnets[*].id

  tags = {
    Name = "geocache_alb"
  }
}

resource "aws_lb_listener" "geocache_alb_http" {
  load_balancer_arn = aws_lb.geocache_alb.arn
  # port80で外からのリクエストを聞く
  port = "80"
  protocol = "HTTP"

  # どのターゲットに向けてやるか
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.geocache.arn
  }
}

# ターゲットのインスタンスのどこにどんな通信を投げるかの設定
resource "aws_lb_target_group" "geocache" {
  name = "geocache"
  port = "80"
  protocol = "HTTP"
  vpc_id = aws_vpc.geocache.id
  target_type = "instance"
  deregistration_delay = "15"

  health_check {
    path = "/"
    protocol = "HTTP"
  }

  tags = {
    Name = "geocache"
  }
  lifecycle {
    ignore_changes = ["lambda_multi_value_headers_enabled"]
  }
}