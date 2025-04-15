#creating auto scaling group
resource "aws_autoscaling_group" "ec2_asg" {
  name                      = "${var.project_name}-ec2-asg"
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  launch_configuration      = aws_launch_configuration.foobar.name
  vpc_zone_identifier       = [var.private_app_subnet_az1_id, var.private_app_subnet_az2_id]
  depends_on = [  ]

  launch_template {
    name = var.aws_launch_template-webserver_launch_template
    version = latest
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ec2-asg"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [ target_group_arns ]
  }
}

#attach autoscaling group to alb target group
resource "aws_autoscaling_attachment" "asg_alb_targrt_attachment" {
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.id
  lb_target_group_arn = var.aws_lb_target_group
}