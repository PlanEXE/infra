//TF_VAR_ASW_ACCESS_KEY
variable "AWS_ACCESS_KEY" {}
//TF_VAR_ASW_SECRET
variable "AWS_SECRET" {}
provider "aws" {
	access_key = "${var.AWS_ACCESS_KEY}"
	secret_key = "${var.AWS_SECRET}"
	region     = "us-east-1"
}

resource "aws_vpc" "planExeVPC" {
	cidr_block       = "172.32.0.0/16"
	enable_dns_support = true
	enable_dns_hostnames = true
	tags = {
		Name = "Plan Exe VPC"
	}
}

resource "aws_subnet" "planExePublicSubnet" {
	vpc_id = "${aws_vpc.planExeVPC.id}"
	cidr_block = "172.32.1.0/24"
	availability_zone = "us-east-1a"
	map_public_ip_on_launch = true
	tags = {
		Name = "Plan Exe Public Subnet"
	}
}

resource "aws_subnet" "planExePrivateSubnet" {
	vpc_id = "${aws_vpc.planExeVPC.id}"
	cidr_block = "172.32.2.0/24"
	availability_zone = "us-east-1b"
	map_public_ip_on_launch = true
	tags = {
		Name = "Plan Exe Private Subnet"
	}
}

resource "aws_internet_gateway" "planExeGateway" {
	vpc_id = "${aws_vpc.planExeVPC.id}"
	tags = {
		Name = "Plan Exe Gateway"
	}
}

resource "aws_route_table" "planExeRouteTable" {
	vpc_id = "${aws_vpc.planExeVPC.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.planExeGateway.id}"
	}
	tags {
		Name = "Plan Exe route table"
	}
}

resource "aws_route_table_association" "planExePublicSubnetRouteAssociation" {
	subnet_id = "${aws_subnet.planExePublicSubnet.id}"
	route_table_id = "${aws_route_table.planExeRouteTable.id}"
}

resource "aws_security_group" "planExePrincipalSecurityGroup" {
	vpc_id = "${aws_vpc.planExeVPC.id}"
	name = "plan_exe_sg_primary"
	description = "Security Group Principal"
	ingress {
		from_port = 80
		protocol = "tcp"
		to_port = 80
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port = 0
		protocol = "-1"
		to_port = 0
		cidr_blocks = ["0.0.0.0/0"]
	}
	tags {
		Name = "Plan Exe Security Group Principal"
	}
}

resource "aws_security_group" "planExeDBSecurityGroup" {
	vpc_id = "${aws_vpc.planExeVPC.id}"
	name = "plan_exe_sg_db"
	description = "Security Group Para la base de datos"
	ingress {
		from_port = 3306
		protocol = "tcp"
		to_port = 3306
		security_groups = ["${aws_security_group.planExePrincipalSecurityGroup.id}"]
	}
	egress {
		from_port = 0
		protocol = "-1"
		to_port = 0
		cidr_blocks = ["0.0.0.0/0"]
	}
	tags {
		Name = "Plan Exe Security Group DB"
	}
}

resource "aws_instance" "planExeMasterInstance" {
	ami = "ami-6869aa05"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.planExePublicSubnet.id}"
	vpc_security_group_ids = ["${aws_security_group.planExePrincipalSecurityGroup.id}"]
	associate_public_ip_address = true
	user_data = <<-EOF
		#!/bin/bash -ex
		yum -y update
		yum -y install httpd php mysql php-mysql
		chkconfig httpd on
		service httpd start
		cd /var/www/html
		wget https://s3-us-west-2.amazonaws.com/us-west-2-aws-training/awsu-spl/spl-13/scripts/app.tgz
		tar xvfz app.tgz
		chown apache:root /var/www/html/rds.conf.php
		EOF
	tags {
		Name = "Plan Exe Master Instance"
	}
}
/*
resource "aws_network_interface" "planExePueblicNetworkInterface" {
	subnet_id   = "${aws_subnet.planExePublicSubnet.id}"
	security_groups = ["${aws_security_group.planExePrincipalSecurityGroup.id}"]
	attachment {
		device_index = 0
		instance = "${aws_instance.planExeMasterInstance.id}"
	}
	tags = {
		Name = "plan_exe_primary_network_interface"
	}
}*/

output "instance_id" {
	value = "${aws_instance.planExeMasterInstance.id}"

}

output "public_dns" {
	value = "${aws_instance.planExeMasterInstance.public_dns}"
}

output "public_ip" {
	value = "${aws_instance.planExeMasterInstance.public_ip}"
}

output "private_dns" {
	value = "${aws_instance.planExeMasterInstance.private_dns}"
}

output "private_ip" {
	value = "${aws_instance.planExeMasterInstance.private_ip}"
}