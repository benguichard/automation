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

# Routes : public
resource "aws_route_table" "pub_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${aws_vpc.vpc.tags.Name} public route table"
  }
}

resource "aws_route_table_association" "pub_route_table_assos" {
  subnet_id      = "${aws_subnet.sbt_public.id}"
  route_table_id = "${aws_route_table.pub_route_table.id}"
}

# Routes : private
resource "aws_route_table" "prv_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }

  tags {
    Name = "${aws_vpc.vpc.tags.Name} private route table"
  }
}

resource "aws_route_table_association" "prv_route_table_assos" {
  subnet_id      = "${aws_subnet.sbt_private.id}"
  route_table_id = "${aws_route_table.prv_route_table.id}"
}

# Networks

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${aws_vpc.vpc.tags.Name} vpc IGW"
  }
}

# NAT

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.sbt_public.id}"

  depends_on = ["aws_internet_gateway.igw"]
}

# Security Groups

resource "aws_security_group" "bastion" {
  name        = "${aws_vpc.vpc.tags.Name} bastion"
  description = "Allow all ssh from trusted networks"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",",var.trusted_networks)}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${aws_vpc.vpc.tags.Name} Bastion rule"
  }
}

resource "aws_security_group" "sshserver" {
  name        = "${aws_vpc.vpc.tags.Name} sshserver"
  description = "Allow all ssh from bastion"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${aws_vpc.vpc.tags.Name} SSH rule"
  }
}

# Bastion

resource "aws_instance" "bastion" {
  ami           = "${lookup(var.bastion_ami, var.aws_region)}"
  instance_type = "${var.bastion_type}"
  key_name      = "${var.key_name}"
  subnet_id     = "${aws_subnet.sbt_public.id}"

  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}",
  ]

  tags {
    Name = "${aws_vpc.vpc.tags.Name} bastion"
  }
}

# Output

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "region" {
  value = "${var.aws_region}"
}

output "public_subnet" {
  value = "${aws_subnet.sbt_public.id}"
}

output "private_subnets" {
  value = "${aws_subnet.sbt_private.id}"
}

output "bastion" {
  value = "${aws_instance.bastion.public_ip}"
}

output "sg_sshserver" {
  value = "${aws_security_group.sshserver.id}"
}
