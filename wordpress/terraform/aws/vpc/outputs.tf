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
