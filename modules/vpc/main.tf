data "aws_availability_zones" "az" {

}
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.system_code}-${var.env_code}-vpc"
    Environment = "${var.env}"
    Owner       = "${var.owner}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  count      = 1
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  # cidr_block = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    "Name" = "Public subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  count      = 1
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)
  # cidr_block = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    "Name" = "Private subnet ${count.index + 1}"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.system_code}-${var.env_code}-private-route-table"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = 1
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
}



