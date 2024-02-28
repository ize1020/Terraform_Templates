# main.tf

# Provider configuration
provider "aws" {
  region = "eu-west-1"  # Choose your desired region
}

# VPC resource
resource "aws_vpc" "Rotem_Vpc" {
  cidr_block = "10.0.0.0/22"  # Updated CIDR block for the VPC
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "Rotem_Vpc"
  }
}

# Define availability zones in the chosen region
variable "availability_zones" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  count       = length(var.availability_zones)
  vpc_id      = aws_vpc.Rotem_Vpc.id
  cidr_block  = cidrsubnet(aws_vpc.Rotem_Vpc.cidr_block, 4, count.index)  # /24 CIDR block
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "PublicSubnet-${element(var.availability_zones, count.index)}"
  }
}

# Route Table resource for Public Subnets
resource "aws_route_table" "public_route_tables" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.Rotem_Vpc.id

  tags = {
    Name = "PublicRouteTable-${element(var.availability_zones, count.index)}"
  }
}

# Associate Public Subnets with Public Route Tables
resource "aws_route_table_association" "public_subnet_associations" {
  count = length(var.availability_zones)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_tables[count.index].id
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  count       = length(var.availability_zones)
  vpc_id      = aws_vpc.Rotem_Vpc.id
  cidr_block  = cidrsubnet(aws_vpc.Rotem_Vpc.cidr_block, 4, count.index + 3)  # /24 CIDR block
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "PrivateSubnet-${element(var.availability_zones, count.index)}"
  }
}

# Route Table resource for Private Subnets
resource "aws_route_table" "private_route_tables" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.Rotem_Vpc.id
}

# Associate Private Subnets with Private Route Tables
resource "aws_route_table_association" "private_subnet_associations" {
  count = length(var.availability_zones)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}
