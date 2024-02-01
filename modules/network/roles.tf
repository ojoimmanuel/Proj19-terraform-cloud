# create IAM role for all instance
resource "aws_iam_role" "dev-role" {
  name = "dev-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "dev-role"
  }
}


# create IAM policy for all instance
resource "aws_iam_policy" "dev-policy" {
  name        = "dev_policy"
  path        = "/"
  description = "dev policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


# attach IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "dev-attach" {
  role       = aws_iam_role.dev-role.name
  policy_arn = aws_iam_policy.dev-policy.arn
}


# create instance profile and attach to the IAM role
resource "aws_iam_instance_profile" "dev-profile" {
  name = "aws_instance_profile_dev-profile"
  role = aws_iam_role.dev-role.name
}


#  provide a public key for the instance
# resource "aws_key_pair" "ndevops" {
#   key_name   = "ndevops"
#   public_key = var.public_key_path
# }
  # public_key_path                = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCs9RznsWOVnocZlqyTReOLuuSX1DdCwjjFEu84RD4FYrBkWfQ51/VLdCNE3+oF5oPPYsobi9ks8uQRp2ed0Zr9G17mAI4k9VoCRwx/3iQi6x5qCGm8vRYHdYS6n9Uaxfr7enQpf5zH9tPmTLinY5S++mcorhOdCSNRFsqGZrK0qJ4qOhYAKJXIukmu6P2yc4YXe566CZOBIsCj5n+OyX+sC4bQ246CaJW5UYkR33XX1zq3aicwfHhp0UZIbRCF92Q0LCQKsnHPa3lumBijdUlOY9oXdUDeA2t7LvyLdYlx5NKTnhLr34eTHHtYWT7MxxDY/4o4mtC2dMnsKAF0woTMrMhpE3gLDRZXZCaSQge4MMrZBU+4fu/c3vgLTs1tXhoMkir6TpClH+h+PtCVIHZEiad3aBYO7HFphPALz0Dv6ZgCZ7BMWg2ugalWI3ND6MVsj14CzSUkUIg06XHCJlMvyGxSrQA2nznzbJUY6kIfEbd9xt+TeppXg0gRZKUYhhc= adeba@DESKTOP-IM4A287"
