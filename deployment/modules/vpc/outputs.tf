output "vpc_id" {
  value = aws_vpc.main.id
}

output "security_group_id" {
  value = aws_security_group.main.id
}

output "subnet_ids" {
  value = [for s in aws_subnet.main : s.id]
}