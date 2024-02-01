# The entire section create a certiface, public zone, and validate the certificate using DNS method

# Create the certificate
resource "aws_acm_certificate" "emydevops" {
  domain_name       = "*.emydevops.online"
  validation_method = "DNS"
}

# calling the hosted zone
data "aws_route53_zone" "emydevops" {
  name         = "emydevops.online"
  private_zone = false
}

# selecting validation method
resource "aws_route53_record" "emydevops" {
  for_each = {
    for dvo in aws_acm_certificate.emydevops.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.emydevops.zone_id
}

# validate the certificate through DNS method
resource "aws_acm_certificate_validation" "emydevops" {
  certificate_arn         = aws_acm_certificate.emydevops.arn
  validation_record_fqdns = [for record in aws_route53_record.emydevops : record.fqdn]
}

# create record for tooling
resource "aws_route53_record" "tooling" {
  zone_id = data.aws_route53_zone.emydevops.zone_id
  name    = "tooling.emydevops.online"
  type    = "A"

  alias {
    name                   = aws_lb.dev-alb.dns_name
    zone_id                = aws_lb.dev-alb.zone_id
    evaluate_target_health = true
  }
}


# create record for wordpress
resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.emydevops.zone_id
  name    = "wordpress.emydevops.online"
  type    = "A"

  alias {
    name                   = aws_lb.dev-alb.dns_name
    zone_id                = aws_lb.dev-alb.zone_id
    evaluate_target_health = true
  }
}