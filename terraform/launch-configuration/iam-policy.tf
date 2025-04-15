# attach SSM permissions to the Bastion role
resource "aws_iam_role_policy" "bastion_ssm_role_policy" {
  name        = "${var.project_name}-bastion_ssm_role_policy"
  role = aws_iam_role.iam_role_bastion.id
  policy = file("${path.module}/iam-policy.json")
}