#fetch public ip
/*data "http" "my_ip" {
    url = "https://ifconfig.me"
}
*/
#security groups for the bastion host 
resource "aws_security_group" "bastion_security_group" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id
  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#creating web-tier ALB security group with ALL traffic for inbound and outbound
resource "aws_security_group" "alb_security_group" {
  name = "alb security group"
  description = "enable http/https access on port 80/443"
  vpc_id = aws_vpc.vpc.id

  #incoming request
  ingress {
    description = "http access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https access"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${var.project_name}-ALB-security-group"
  }
}

#create security group for web server
resource "aws_security_group" "webserver_sg" {
  name = "webserver security group"
  description = "enable http/https access on port 80/443 via alb sg "
  vpc_id = aws_vpc.vpc.id

  #incoming request
  ingress {
    description = "http access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description = "https access"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }
  
  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${var.project_name}-webserver-sg"
      }
}

#create security group for database
resource "aws_security_group" "database_sg" {
  name = "database security group"
  description = "enable mysql/aurora access on port 3306"
  vpc_id = aws_vpc.vpc.id

  #incoming request
  ingress {
    description = "mysql/aurora access"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }
  
  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${var.project_name}-database-sg"
  }
}
