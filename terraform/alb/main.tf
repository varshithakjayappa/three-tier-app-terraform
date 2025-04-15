#creating application load balancer, target group and listeneers for web and app tier
#creating alb for web tier
resource "aws_lb" "application_load_balancer" {
  name               = "${var.project_name}-alb"
  internal = false
  load_balancer_type = "application"
  subnets = [var.public_subnet_az1_cidr, var.public_subnet_az2_cidr]
  security_groups = [var.alb_security_group_id]

  tags ={
    Name = "${var.project_name}-web-alb"
  }
}

#creating target group for web tier
resource "aws_lb_target_group" "alb_target_group" {
  name = "${var.project_name}-web_target_group"
  port     = 80
  target_type = "instance"
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5 
  }

  tags ={
    Name = "${var.project_name}-web_target_group"
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#craeting ALB listener with port 80 and attaching it to web-tier target group
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

