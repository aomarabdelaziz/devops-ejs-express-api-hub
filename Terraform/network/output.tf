output "vpc_id" {
  value = aws_vpc.myapp-vpc.id
}

output "az_subnets_ids" {
  value = aws_subnet.az-subnets[*].id
}
