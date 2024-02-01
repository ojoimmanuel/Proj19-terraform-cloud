# ---- Autoscaling for wordpress application

resource "aws_autoscaling_group" "wordpress-asg" {
  name                      = "wordpress-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  vpc_zone_identifier = [
    var.private_subnets-1,
    var.private_subnets-2
  ]

  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "david-wordpress"
    propagate_at_launch = true
  }
}


# attaching autoscaling group of  wordpress application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_wordpress" {
  autoscaling_group_name = aws_autoscaling_group.wordpress-asg.id
  lb_target_group_arn   = var.wordpress-alb-tgt
}





# ---- Autoscaling for tooling -----

resource "aws_autoscaling_group" "tooling-asg" {
  name                      = "tooling-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  vpc_zone_identifier = [
    var.private_subnets-1,
    var.private_subnets-2
  ]

  launch_template {
    id      = aws_launch_template.tooling.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "david-tooling"
    propagate_at_launch = true
  }
}


# attaching autoscaling group of  tooling application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
  autoscaling_group_name = aws_autoscaling_group.tooling-asg.id
  lb_target_group_arn   = var.tooling-alb-tgt
}
