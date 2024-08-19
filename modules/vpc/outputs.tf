output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}

output "vpc_cidr" {
  value = var.cidr_block
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnets.*.id
}

output "custom_public_sg" {
  value = aws_security_group.custom_sg_public.id
}