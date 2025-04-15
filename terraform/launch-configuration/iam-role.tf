#creating IAM Roles for EC2 throush SSM manager
resource "aws_iam_role" "bastion_ssm_role" {
  name = "${var.project_name}-bastion_ssm_role"

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
    tag-key = "${var.project_name}-bastion_ssm_role"
  }
}

resource "aws_iam_instance_profile" "bastion_ssm_role" {
  name = "${var.project_name}-bastion_ssm_role"
  role = aws_iam_role.iam_role_bastion.name
}