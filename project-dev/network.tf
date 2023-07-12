## VPC

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
      Name = var.env
  }
}


## Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

}

##EIP for NAT
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public.id
}

## Route Table

resource "aws_route_table" "instance-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.env
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
}


## Subnet

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub_subnet_cidr
  availability_zone = var.zone

  tags = {
    Name = "pub-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pri_subnet_cidr
  availability_zone = var.zone

  tags = {
    Name = "pri-subnet"
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.instance-table.id
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private-route-table.id
}

# Security group to allow port 22, 80, 443

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

resource "aws_security_group" "general_sg" {
  description = "egress for updates"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "out_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.general_sg.id
}

# Create a network interface with an ip in the pub subnet

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.public.id
  private_ips     = [var.web_server_private_ip]
  security_groups = [aws_security_group.allow_web.id]

}

resource "aws_network_interface" "app-server-nic" {
  subnet_id       = aws_subnet.private.id
  private_ips     = [var.app_server_private_ip]
}

# Assign an elastic IP to the network interface created

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = var.web_server_private_ip
  depends_on = [aws_internet_gateway.gw]
}