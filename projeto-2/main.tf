terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2-iac-aula2" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.small"

  tags={
    Name = "ec2-iac-aula2"
  }

  ebs_block_device { //Bloco de armazenamento (disco)
    device_name = "/dev/sda1"
    volume_size = 30
    volume_type = "gp3"
  }


}