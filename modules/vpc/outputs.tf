# Output the VPC ID
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

# Output the public subnet IDs
output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

# Output the private subnet IDs
output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

# Output the intra subnet IDs
output "intra_subnet_ids" {
  description = "The IDs of the intra subnets"
  value       = [for subnet in aws_subnet.intra : subnet.id]
}

# Output the internet gateway ID
output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.igw.id
}

# Output the public route table ID
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

# Output the NAT gateway ID (if enabled)
output "nat_gateway_id" {
  description = "The ID of the NAT gateway (if enabled)"
  value       = var.enable_nat_gateway ? aws_nat_gateway.nat[0].id : null
}

# Output the Elastic IP ID for the NAT gateway (if enabled)
output "nat_eip_id" {
  description = "The ID of the Elastic IP for the NAT gateway (if enabled)"
  value       = var.enable_nat_gateway ? aws_eip.nat[0].id : null
}

# Output the private route table ID
output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}