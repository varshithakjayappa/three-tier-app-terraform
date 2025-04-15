# export the alb security group id
output "alb_security_group_id" {
  value = aws_security_group.alb_security_group.id
}

# export the web server security group id
output "webserver_sg_id" {
  value = aws_security_group.webserver_sg.id
}

# export the database security group id
output "database_sg_id" {
  value = aws_security_group.database_sg.id
}