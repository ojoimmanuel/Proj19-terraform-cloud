# ----------------------------
#External Load balancer for reverse proxy nginx
#---------------------------------

resource "aws_lb" "dev-alb" {
  name            = "dev-alb"
  internal        = false
  security_groups = [var.public-sg]
  subnets = [var.public-sbn-1,
  var.public-sbn-2, ]

  tags = {
    Name = "dev-alb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

#--- create a target group for the load balancer
resource "aws_lb_target_group" "dev-nginx-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "dev-nginx-tgt"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

#--- create a listener for the load balancer

resource "aws_lb_listener" "dev-nginx-listner" {
  load_balancer_arn = aws_lb.dev-alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.emydevops.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev-nginx-tgt.arn
  }
}

resource "aws_lb_listener" "dev-nginx-listner-80" {
  load_balancer_arn = aws_lb.dev-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev-nginx-tgt.arn
  }
}

# ----------------------------
#Internal Load Balancers for webservers
#---------------------------------

resource "aws_lb" "dev-ialb" {
  name            = "dev-ialb"
  internal        = true
  security_groups = [var.private-sg]
  subnets = [var.private-sbn-1,
  var.private-sbn-2, ]

  tags = {
    Name = "dev-ialb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}


# --- target group and listener for wordpress -------

resource "aws_lb_target_group" "dev-wordpress-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "dev-wordpress-tgt"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}


# --- target group for tooling -------

resource "aws_lb_target_group" "dev-tooling-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "dev-tooling-tgt"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

# For this aspect a single listener was created for the wordpress which is default,
# A rule was created to route traffic to tooling when the host header changes


resource "aws_lb_listener" "dev-web-listener" {
  load_balancer_arn = aws_lb.dev-ialb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev-wordpress-tgt.arn
  }
}

# listener rule for tooling target

resource "aws_lb_listener_rule" "dev-listener" {
  listener_arn = aws_lb_listener.dev-web-listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev-tooling-tgt.arn
  }

  condition {
    host_header {
      values = ["tooling.emydevops.online"]
    }
  }
}














