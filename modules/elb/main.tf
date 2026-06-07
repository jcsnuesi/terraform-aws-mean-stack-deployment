resource "aws_lb" "app_alb" {
  name               = "mean-app-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.sg_id]
  internal           = false

  tags = {
    Name = "mean-alb"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name        = "mean-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "tg_attachments" {
  count            = length(var.target_ids)
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = var.target_ids[count.index]
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
