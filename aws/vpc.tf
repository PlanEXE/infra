provider "aws" {
	access_key = "${var.AWS_ACCESS_KEY}"
	secret_key = "${var.AWS_SECRET}"
	region     = "${var.region}"
}

resource "aws_vpc" "planExeVPC" {
	cidr_block       = "${var.vpc_cidr}"
	enable_dns_support = true
	enable_dns_hostnames = true
	tags = {
		Name = "Plan Exe VPC"
	}
}

resource "aws_subnet" "planExePublicSubnet1" {
	depends_on = ["aws_vpc.planExeVPC"]
	vpc_id = "${aws_vpc.planExeVPC.id}"
	cidr_block = "${var.subnet1_cidr}"
	availability_zone = "${var.region}a"
	map_public_ip_on_launch = true
	tags = {
		Name = "Plan Exe Public Subnet 1"
	}
}

resource "aws_subnet" "planExePublicSubnet2" {
	depends_on = ["aws_vpc.planExeVPC"]
	vpc_id = "${aws_vpc.planExeVPC.id}"
	cidr_block = "${var.subnet2_cidr}"
	availability_zone = "${var.region}b"
	map_public_ip_on_launch = true
	tags = {
		Name = "Plan Exe Public Subnet 2"
	}
}

resource "aws_subnet" "planExePublicSubnet3" {
	depends_on = ["aws_vpc.planExeVPC"]
	vpc_id = "${aws_vpc.planExeVPC.id}"
	cidr_block = "${var.subnet3_cidr}"
	availability_zone = "${var.region}c"
	map_public_ip_on_launch = true
	tags = {
		Name = "Plan Exe Public Subnet 3"
	}
}

resource "aws_internet_gateway" "planExeGateway" {
	depends_on = ["aws_vpc.planExeVPC"]
	vpc_id = "${aws_vpc.planExeVPC.id}"
	tags = {
		Name = "Plan Exe Gateway"
	}
}

resource "aws_route_table" "planExeRouteTable" {
	depends_on = ["aws_vpc.planExeVPC"]
	vpc_id = "${aws_vpc.planExeVPC.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.planExeGateway.id}"
	}
	tags {
		Name = "Plan Exe route table"
	}
}

resource "aws_route_table_association" "planExePublicSubnet1RouteAssociation" {
	depends_on = ["aws_subnet.planExePublicSubnet1", "aws_route_table.planExeRouteTable"]
	subnet_id = "${aws_subnet.planExePublicSubnet1.id}"
	route_table_id = "${aws_route_table.planExeRouteTable.id}"
}

resource "aws_route_table_association" "planExePublicSubnet2RouteAssociation" {
	depends_on = ["aws_subnet.planExePublicSubnet2", "aws_route_table.planExeRouteTable"]
	subnet_id = "${aws_subnet.planExePublicSubnet2.id}"
	route_table_id = "${aws_route_table.planExeRouteTable.id}"
}

resource "aws_route_table_association" "planExePublicSubnet3RouteAssociation" {
	depends_on = ["aws_subnet.planExePublicSubnet3", "aws_route_table.planExeRouteTable"]
	subnet_id = "${aws_subnet.planExePublicSubnet3.id}"
	route_table_id = "${aws_route_table.planExeRouteTable.id}"
}

/*
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
}

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
}*/
