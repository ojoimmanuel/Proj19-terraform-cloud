
# creating launch templates for wordpress hosts

resource "aws_launch_template" "wordpress" {
  image_id               = var.ami-web
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.web-sg]


  iam_instance_profile {
    name = var.instance_profile
  }

  key_name = var.keypair

  // network_interfaces {
  //   associate_public_ip_address = false

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
      Name = "test"
    }
  }

  // user_data = filebase64("${path.module}/wordpress.sh")
}



# creating launch templates for tooling hosts
resource "aws_launch_template" "tooling" {
  image_id               = var.ami-web
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.web-sg]


  iam_instance_profile {
    name = var.instance_profile
  }

  key_name = var.keypair

  // network_interfaces {
  //   associate_public_ip_address = false
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
      Name = "test"
    }
  }

  // user_data = filebase64("${path.module}/tooling.sh")
}
