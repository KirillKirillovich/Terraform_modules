resource "aws_vpc" "custom_vpc" {
  cidr_block       = var.cidr_block

  tags = merge(
    var.tags,
    {},
  )
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = merge(
    var.tags,
    {},
  )
}


resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.available_zones, count.index)
  map_public_ip_on_launch = var.public_ip_launch

  tags = merge(
    var.tags,
    {
        SubnetName = "Public Subnet ${count.index +1}"
    },
  )
}

resource "aws_subnet" "private_subnets" {
  count      = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.available_zones, count.index)

  tags = merge(
    var.tags,
    {
        SubnetName = "Private Subnet ${count.index +1}"
    },
  )
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.internet_gw.id
 }

}

resource "aws_route_table_association" "public_subnet_assoc" {
  count = length(var.public_subnet_cidr)
  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "custom_sg_public" {
  name        = "Public SG"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.custom_vpc.id

dynamic "ingress" {
    for_each = var.sg_allowed_ports
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port = 9100
    to_port = 9100
    protocol = "tcp"
    cidr_block = var.cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {},
  )
}
