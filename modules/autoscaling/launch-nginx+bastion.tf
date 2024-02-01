# creating launch templates for bastion hosts
resource "aws_launch_template" "bastion" {
  image_id               = var.ami-bastion
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.bastion-sg]

  iam_instance_profile {
    name = var.instance_profile
  }

  key_name = var.keypair

  // network_interfaces {
  //   associate_public_ip_address = true

  // }

  placement {
    availability_zone = var.template_az
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "dev-bastion"
    }
  }

  // user_data = filebase64("${path.module}/bastion.sh")
}

# creating tooling launch templates for nginx hosts

resource "aws_launch_template" "nginx" {
  image_id               = var.ami-nginx
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.nginx-sg]

  iam_instance_profile {
    name = var.instance_profile
  }

  key_name = var.keypair

  // network_interfaces {
  //   associate_public_ip_address = true

  // }

  placement {
    availability_zone = var.template_az
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "dev-nginx"
    }
  }

  // user_data = filebase64("${path.module}/bastion.sh")
}


