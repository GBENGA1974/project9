# WEBSERVER1 instance

resource "aws_instance" "webserver1" {
	ami = var.ami
	instance_type = var.instance_type
    key_name = "ec2-key"
    count = 1
    subnet_id = aws_subnet.project9-pubsubnet1.id
    availability_zone = "eu-west-2a"
    vpc_security_group_ids = [aws_security_group.PROJECT9-vpc-security-group.id]
    associate_public_ip_address = true

user_data = <<EOF
#!/bin/bash 
# Please make sure to launch Amazon Linux 2 
yum update -y 
yum install -y httpd 
systemctl start httpd 
systemctl enable httpd

EOF
}

resource "aws_instance" "webserver2" {
	ami = var.ami
	instance_type = var.instance_type
    key_name = "ec2-key"
    count = 1
    subnet_id = aws_subnet.project9-pubsubnet2.id
    availability_zone = "eu-west-2b"
    vpc_security_group_ids = [aws_security_group.PROJECT9-vpc-security-group.id]
    associate_public_ip_address = true

user_data = <<EOF
#!/bin/bash 
# Please make sure to launch Amazon Linux 2 
yum update -y 
yum install -y httpd 
systemctl start httpd 
systemctl enable httpd

EOF
}