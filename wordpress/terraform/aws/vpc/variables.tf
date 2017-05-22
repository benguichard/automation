# Global

variable "stack_name" {
  default = "wordpress"
}

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
