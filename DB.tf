# PROJECT9 DATABASE 
# SECURITY GROUP FOR DATABASE instance

resource "aws_security_group" "project9-DB-secgrp" {
  name              = "project9-db_sec-group"
  description       = "Allow mysql inbound traffic"
  vpc_id            = aws_vpc.PROJECT9-VPC.id

}

resource "aws_security_group_rule" "PROJECT9-inbound" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.project9-DB-secgrp.id
}

resource "aws_security_group_rule" "PROJECT9-outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.project9-DB-secgrp.id
}

# aws_db_instance

resource "aws_db_instance" "mysqldatabase" {
  allocated_storage    = 12
  count = "2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mysql-project9"
  username             = "project9"
  password             = "Emmanuel1974"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.project_db_group.name
}

# MYSQL DATABASE SUBNET GROUP

resource "aws_db_subnet_group" "project_db_group" {
  name       = "project9-db1"
  subnet_ids = [aws_subnet.project9-prisubnet1.id, aws_subnet.project9-prisubnet2.id]

  tags = {
    Name = "mysqldb-subnet group"
  }
}


