# VPC creation
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.vpc_name}"
  }
}

# Creating 4 public subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.public-subnet}-${count.index + 1}"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.igw_name}"
  }
}
# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.public-route-table}"
  }
}

# Associate route table with subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow SSH"
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
    Name = "${var.SG_allow-ssh}"
  }
}

# Key Pair
#resource "tls_private_key" "key_pair" {
# algorithm = "RSA"
# rsa_bits  = 4096
#}

#resource "aws_key_pair" "main" {
# key_name   = "Dev-Keypair"
#public_key = tls_private_key.key_pair.public_key_openssh
#}

# EC2 Instance
resource "aws_instance" "Master" {

  ami           = var.ami_id
  instance_type = var.instance_type
  #count                       = length(var.Master-servers)
  count     = length(var.instance_names)
  subnet_id = element(aws_subnet.public[*].id, 0)
  #key_name                    = aws_key_pair.main.key_name
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = var.instance_names[count.index]
  }


}



