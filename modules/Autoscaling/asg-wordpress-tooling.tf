# launch template for wordpress

resource "aws_launch_template" "wordpress-launch-template" {
  image_id               = var.ami-web
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.web-sg
  # vpc_security_group_ids = [aws_security_group.webserver-sg.id]

  iam_instance_profile {
    # name = aws_iam_instance_profile.ip.id
    name = var.instance_profile
  }

  key_name = var.keypair


  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = format("%s-wordpress-launch-template", var.name)
      },
    )

  }

  # create a file called wordpress.sh and copy the wordpress userdata from project 15 into it.
  user_data = filebase64("${path.module}/wordpress.sh")
}


# ---- Autoscaling for wordpress application

resource "aws_autoscaling_group" "wordpress-asg" {
  name                      = "wordpress-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  # vpc_zone_identifier = [

  #   aws_subnet.private[0].id,
  #   aws_subnet.private[1].id
  # ]

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.wordpress-launch-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "wordpress-asg"
    propagate_at_launch = true
  }
}


# attaching autoscaling group of wordpress application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_wordpress" {
  autoscaling_group_name = aws_autoscaling_group.wordpress-asg.id
  # lb_target_group_arn    = aws_lb_target_group.wordpress-tgt.arn
  lb_target_group_arn    = var.wordpress-alb-tgt.arn
}


# launch template for tooling
resource "aws_launch_template" "tooling-launch-template" {
  image_id               = var.ami-web
  instance_type          = "t2.micro"
  # vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  vpc_security_group_ids = var.web-sg
  iam_instance_profile {
    # name = aws_iam_instance_profile.ip.id
    name = var.instance_profile
  }

  key_name = var.keypair


  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = format("%s-tooling-launch-template", var.name)
      },
    )

  }

  # create a file called tooling.sh and copy the tooling userdata from project 15 into it
  user_data = filebase64("${path.module}/tooling.sh")
}



# ---- Autoscaling for tooling -----

resource "aws_autoscaling_group" "tooling-asg" {
  name                      = "tooling-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  # vpc_zone_identifier = [

  #   aws_subnet.private[0].id,
  #   aws_subnet.private[1].id
  # ]

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.tooling-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "tooling-launch-template"
    propagate_at_launch = true
  }
}

# attaching autoscaling group of  tooling application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
  autoscaling_group_name = aws_autoscaling_group.tooling-asg.id
  # lb_target_group_arn    = aws_lb_target_group.tooling-tgt.arn
  lb_target_group_arn    = var.tooling-tgt.arn
}