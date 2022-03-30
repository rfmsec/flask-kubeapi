terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "= 4.3.0"
    }
  }
}

provider "aws" {
  shared_config_files      = ["aws/config"]
  shared_credentials_files = ["aws/credentials"]
  profile                  = "default"
}

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "main" {
   vpc_id = aws_vpc.main.id
   cidr_block = "10.10.10.0/24"
}

resource "aws_security_group" "SG_for_kind" {
  name        = "king_sg"
  description = "Allow inbound SSH and http 8080"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from all"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"] 
  } 

  ingress {
    description      = "http from all"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"] 
  } 
  
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "kind_sg"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "default" {
  route_table_id = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gateway.id
}

resource "aws_instance" "amazon-kind" {
  instance_type = "t2.micro"
  ami = "ami-0dcc0ebde7b2e00db"
  security_groups = [aws_security_group.SG_for_kind.id]
  subnet_id = aws_subnet.main.id
  associate_public_ip_address = true
  user_data = <<-EOL
#!/bin/bash
wget https://raw.githubusercontent.com/rfmsec/Learning/master/setup-kind.sh
chmod +x setup-kind.sh
./setup-kind.sh
EOL
  tags = {
    "Name" = "kind"
  }
}
