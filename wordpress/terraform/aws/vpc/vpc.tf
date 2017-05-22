# AWS configuration

provider "aws" {
  region = "${var.aws_region}"
}

# VPC

resource "aws_vpc" "vpc" {
  cidr_block = "${var.base_network}"

  tags {
    Name = "${var.stack_name} vpc"
  }
}

# Subnets

resource "aws_subnet" "sbt_public" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_networks}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "${aws_vpc.vpc.tags.Name} public subnet"
  }
}

resource "aws_subnet" "sbt_private" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.private_networks}"
  map_public_ip_on_launch = "false"

  tags {
    Name = "${aws_vpc.vpc.tags.Name} private subnet"
  }
}
