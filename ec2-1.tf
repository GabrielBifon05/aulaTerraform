resource "aws_instance" "ec2-terraform1" {
  ami = "ami-0e86e20dae9224db8"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 40
    volume_type= "gp3"
  }

  instance_type = "t2.small"
  tags = {
    Name = "ec2-aulaterraform1-separado"
  }
}

//um volume de dados EBS de 40 GB do tipo gp3
