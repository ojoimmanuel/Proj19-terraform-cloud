output "ALB-sg" {
  value = aws_security_group.emy["ext-alb-sg"].id
}


output "IALB-sg" {
  value = aws_security_group.emy["int-alb-sg"].id
}


output "bastion-sg" {
  value = aws_security_group.emy["bastion-sg"].id
}


output "nginx-sg" {
  value = aws_security_group.emy["nginx-sg"].id
}


output "web-sg" {
  value = aws_security_group.emy["webserver-sg"].id
}


output "datalayer-sg" {
  value = aws_security_group.emy["datalayer-sg"].id
}

