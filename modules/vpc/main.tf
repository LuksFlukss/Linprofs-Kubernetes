# Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = var.name
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  for_each = { for i, subnet in var.public_subnets : i => subnet }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.azs[tonumber(each.key)]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-public-${each.key}"
    "kubernetes.io/role/elb" = 1
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  for_each = { for i, subnet in var.private_subnets : i => subnet }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.azs[tonumber(each.key)]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-private-${each.key}"
    "kubernetes.io/role/internal-elb" = 1
  }
}

# Create intra subnets (if defined)
resource "aws_subnet" "intra" {
  for_each = { for i, subnet in var.intra_subnets : i => subnet }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.azs[tonumber(each.key)]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-intra-${each.key}"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-igw"
  }
}

# Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-public"
  }
}

# Add a default route to the internet gateway in the public route table
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate public route table with public subnets
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Create NAT gateway (if enabled)
resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public["0"].id
  tags = {
    Name = "${var.name}-nat"
  }
}

# Create Elastic IP for NAT gateway
resource "aws_eip" "nat" {
  count      = var.enable_nat_gateway ? 1 : 0
  domain     = "vpc"
  tags = {
    Name = "${var.name}-nat-eip"
  }
}

# Create private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-private-route-table"
  }
}

# Add a default route to the NAT gateway in the private route table
resource "aws_route" "private" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

# Associate private route table with private subnets
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}