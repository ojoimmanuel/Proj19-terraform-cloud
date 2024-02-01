#output the External Load balancaer DNS
output "alb_dns_name" {
  description = "External Load balancaer DNS"
  value       = aws_lb.dev-alb.dns_name
}

# output the External Load balancaer target group
output "dev-nginx-tgt" {
  description = "External Load balancaer target group"
  value       = aws_lb_target_group.dev-nginx-tgt.arn
}


# Output External Load balancaer target group
output "dev-wordpress-tgt" {
  description = "External Load balancaer target group"
  value       = aws_lb_target_group.dev-wordpress-tgt.arn
}



# Output the External Load balancaer target group
output "dev-tooling-tgt" {
  description = "External Load balancaer target group"
  value       = aws_lb_target_group.dev-tooling-tgt.arn
}



