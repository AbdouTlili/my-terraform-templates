
// ceating the main vpc 
resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"

}

//creating the main subnet 
resource "aws_subnet" "main-public-subnet" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

}

// creating the internet gw 
resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-igw"
  }
}

//creating route table 
resource "aws_route_table" "vpc-route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_internet_gateway.id
  }

}


// assiciating the subnet with the routing table 

resource "aws_route_table_association" "rt-subnet-association" {
  subnet_id      = aws_subnet.main-public-subnet.id
  route_table_id = aws_route_table.vpc-route-table.id
}

// creating a  security group 
resource "aws_security_group" "allow-ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main-vpc.id

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow-ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow-ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}