resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.project_tags, { Name = "${var.project_tags.Project}-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.project_tags, { Name = "${var.project_tags.Project}-igw" })
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = merge(var.project_tags, { Name = "${var.project_tags.Project}-public-${count.index + 1}" })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  tags = merge(var.project_tags, { Name = "${var.project_tags.Project}-private-${count.index + 1}" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.project_tags, { Name = "${var.project_tags.Project}-rt-public" })
}

resource "aws_route" "public_rt_default" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway for private subnets
resource "aws_eip" "nat" {
  count = length(aws_subnet.public)
  # Removed invalid attribute "vpc"
  tags = merge(var.project_tags, { Name = "${var.project_tags.Project}-nat-eip-${count.index + 1}" })
}

resource "aws_nat_gateway" "nat" {
  count = length(aws_subnet.public)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id = aws_subnet.public[count.index].id
  tags = merge(var.project_tags, { Name = "${var.project_tags.Project}-nat-${count.index + 1}" })
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  count = length(aws_subnet.private)
  vpc_id = aws_vpc.this.id
  tags = merge(var.project_tags, { Name = "${var.project_tags.Project}-rt-private-${count.index + 1}" })
}

resource "aws_route" "private_default" {
  count = length(aws_route_table.private)
  route_table_id = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "private_assoc" {
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }
