provider "aws" {
  region = ""  
}

variable "instance_type" {
  description = "The instance type for the virtual machine"
  default     = "t2.micro"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the virtual network"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidr_block
}

resource "aws_security_group" "my_security_group" {
  name_prefix = "my-security-group"

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
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = var.instance_type
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "MyEC2Instance"
  }
}

resource "aws_eip" "my_public_ip" {
  instance = aws_instance.my_instance.id
}

output "public_ip" {
  value = aws_eip.my_public_ip.public_ip
}
