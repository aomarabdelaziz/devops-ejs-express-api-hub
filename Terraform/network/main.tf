resource "aws_vpc" "myapp-vpc" {

  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}


resource "aws_subnet" "az-subnets" {
  count = length(var.subnets_az)

  vpc_id                  = aws_vpc.myapp-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone       = var.subnets_az[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-subnet-${count.index}"
  }
}


resource "aws_route_table_association" "myapp-rtb-az-subnets" {
  count = length(var.subnets_az)

  subnet_id      = aws_subnet.az-subnets[count.index].id
  route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

resource "aws_default_route_table" "myapp-main-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-rtb"
  }
}
