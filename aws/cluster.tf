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
	description = "Security Group Principal"
	ingress {
		from_port = 80
		protocol = "tcp"
		to_port = 80
		cidr_blocks = ["0.0.0.0/0"]
	}
	tags {
		Name = "Plan Exe Security Group Principal"
	}
}