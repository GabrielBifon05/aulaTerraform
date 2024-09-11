

// Criação de VPC
resource "aws_vpc" "vpc_labTerraform_sptech" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-labTerraform-sptech"
  }
}

// Criação de Subnet Pública
resource "aws_subnet" "sub_az1_pub_labTerraform_sptech" {
  vpc_id            = aws_vpc.vpc_labTerraform_sptech.id
  cidr_block        = "10.0.1.0/24"
  //enable_resource_name_dns_a_record_on_launch =
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "sub-az1-pub-labTerraform-sptech"
  }
}

// Criação de Subnet Privada
resource "aws_subnet" "sub_az_pri_labTerraform_sptech" {
  vpc_id            = aws_vpc.vpc_labTerraform_sptech.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "sub-az-pri-labTerraform-sptech"
  }
}

// Criação do Gateway de Internet
resource "aws_internet_gateway" "igw_labTerraform_sptech" {
  vpc_id = aws_vpc.vpc_labTerraform_sptech.id

  tags = {
    Name = "igw-labTerraform-sptech"
  }
}

// Criação da Tabela de Rotas e Associação com Subnet
resource "aws_route_table" "rtb_public_labTerraform_sptech" {
  vpc_id = aws_vpc.vpc_labTerraform_sptech.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_labTerraform_sptech.id
  }

  tags = {
    Name = "rtb-public-labTerraform-sptech"
  }
}

// Associação da Tabela de Rotas com a Subnet Pública
resource "aws_route_table_association" "rta_sub_az1_pub_labTerraform_sptech" {
  subnet_id      = aws_subnet.sub_az1_pub_labTerraform_sptech.id
  route_table_id = aws_route_table.rtb_public_labTerraform_sptech.id
}


// Instância EC2 1 configurando portas (security group)
resource "aws_security_group" "sg_ec2_sptech" {
  vpc_id = aws_vpc.vpc_labTerraform_sptech.id

  ingress {
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
    Name = "sg-ec2-sptech"
  }
}



// Instância EC2 1 na subnet publica
resource "aws_instance" "ec2_iac_1_sptech" {
  ami             = "ami-0e86e20dae9224db8"
  instance_type   = "t2.small"
  subnet_id       = aws_subnet.sub_az1_pub_labTerraform_sptech.id
  security_groups = [aws_security_group.sg_ec2_sptech.name]

  depends_on = [aws_security_group.sg_ec2_sptech]  # Assegura que o SG é criado primeiro

  tags = {
    Name = "ec2-iac-1-sptech"
  }
}


// Instância EC2 2 na subnet privada
resource "aws_instance" "ec2_iac_2_sptech" {
  ami             = "ami-0e86e20dae9224db8"
  instance_type   = "t2.small"
  subnet_id       = aws_subnet.sub_az_pri_labTerraform_sptech.id
  tags = {
    Name = "ec2-iac-2-sptech"
  }
}
