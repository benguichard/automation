# Global

variable "stack_name" {
  default = "wordpress"
}

variable "key_name" {}

# AWS

variable "aws_region" {}

# Networks

variable "base_network" {
  default = "10.0.0.0/16"
}

variable "public_networks" {
  default = "10.0.0.0/24"
}

variable "private_networks" {
  default = "10.0.1.0/24"
}

variable "trusted_networks" {
  default = "0.0.0.0/0"
}

# Bastion AMIs
variable "bastion_ami" {
  default = {
    # Ubuntu 16.04 LTS
    eu-west-1 = "ami-b1cf19c6"
    eu-west-2 = "ami-f1d7c395"
  }
}

variable "bastion_type" {
  default = "t2.micro"
}
