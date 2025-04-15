resource "aws_launch_template" "webserver_launch_template" {
    name = "${var.project_name}-launch-template"
    image_id = var.image_id
    instance_type = var.ec2_instance_type
    description = "launch template"
    update_default_version = true
    vpc_security_group_ids = [var.webserver_sg_id]
    iam_instance_profile {
      name = aws_iam_instance_profile.bastion_ssm_role.name
    }
    user_data = base64encode(templatefile("${path.module}/nest-app.sh.tpl",{
        PROJECT_NAME  = var.project_name
        ENVIRONMENT   = var.env
        RDS_ENDPOINT  = var.rds_endpoint
        RDS_DB_NAME   = var.database_name
        USERNAME      = var.database_username
        PASSWORD      = var.database_password
        RECORD_NAME   = var.record_names
    }))
}