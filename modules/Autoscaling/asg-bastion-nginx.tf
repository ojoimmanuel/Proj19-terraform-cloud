# creating sns topic for all the auto scaling groups
resource "aws_sns_topic" "emy-sns" {
  name = "Default_CloudWatch_Alarms_Topic"
}


# creating notification for all the auto scaling groups
resource "aws_autoscaling_notification" "emy_notifications" {
  group_names = [
    aws_autoscaling_group.bastion-asg.name,
    aws_autoscaling_group.nginx-asg.name,
    aws_autoscaling_group.wordpress-asg.name,
    aws_autoscaling_group.tooling-asg.name,
  ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.emy-sns.arn
}


# resource "random_shuffle" "az_list" {
#   # input = data.aws_availability_zones.available.names
#   input = var.avail_az
# }


# launch template for bastion

resource "aws_launch_template" "bastion-launch-template" {
  image_id               = var.ami-bastion
  instance_type          = "t2.micro"
  # vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  vpc_security_group_ids = var.bastion-sg
  iam_instance_profile {
    # name = aws_iam_instance_profile.ip.id
    name = var.instance_profile

  }

  key_name = var.keypair

  # placement {
  #   availability_zone = "random_shuffle.az_list.result"
  # }

  placement {
    availability_zone = var.avail_az
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = format("%s-bastion-launch-template", var.name)
      },
    )
  }


  # create a file called bastion.sh and copy the bastion userdata from project 15 into it
  # user_data = filebase64("${path.module}/bastion.sh")
}



# ---- Autoscaling for bastion  hosts

resource "aws_autoscaling_group" "bastion-asg" {
  name                      = "bastion-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  # vpc_zone_identifier = [
  #   aws_subnet.public[0].id,
  #   aws_subnet.public[1].id
  # ]

  vpc_zone_identifier = var.public_subnets


  launch_template {
    id      = aws_launch_template.bastion-launch-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "bastion-launch-template"
    propagate_at_launch = true
  }

}


# launch template for nginx

resource "aws_launch_template" "nginx-launch-template" {
  image_id               = var.ami-nginx
  instance_type          = "t2.micro"
  # vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  vpc_security_group_ids = var.nginx-sg
  iam_instance_profile {
    # name = aws_iam_instance_profile.ip.id
    name = var.instance_profile
 }

  key_name = var.keypair

  # placement {
  #   availability_zone = "random_shuffle.az_list.result"
  # }

  placement {
    availability_zone = var.avail_az
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = format("%s-nginx-launch-template", var.name)
      },
    )
  }

  # create a file called nginx.sh and copy the nginx userdata from project 15 into it
  # user_data = filebase64("${path.module}/nginx.sh")
}


# ------ Autoscslaling group for reverse proxy nginx ---------

resource "aws_autoscaling_group" "nginx-asg" {
  name                      = "nginx-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  # vpc_zone_identifier = [
  #   aws_subnet.public[0].id,
  #   aws_subnet.public[1].id
  # ]

  vpc_zone_identifier = var.public_subnets

  launch_template {
    id      = aws_launch_template.nginx-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "nginx-launch-template"
    propagate_at_launch = true
  }


}

# attaching autoscaling group of nginx to external load balancer
resource "aws_autoscaling_attachment" "asg_attachment_nginx" {
  autoscaling_group_name = aws_autoscaling_group.nginx-asg.id
  lb_target_group_arn    = var.nginx-alb-tgt
}