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