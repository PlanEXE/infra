variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET" {}
provider "aws" {
	access_key = "${var.AWS_ACCESS_KEY}"
	secret_key = "${var.AWS_SECRET}"
	region     = "us-east-1"
}

resource "aws_instance" "example" {
	ami           = "ami-01e3b8c3a51e88954"
	instance_type = "t2.micro"
}