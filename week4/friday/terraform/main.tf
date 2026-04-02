provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "kijanikiosk_sg" {
  name        = "kijanikiosk-sg"
  description = "Security group for KijaniKiosk app servers"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

locals {
  servers = {
    api      = "kijanikiosk-api"
    payments = "kijanikiosk-payments"
    logs     = "kijanikiosk-logs"
  }
}

module "app_server" {
  source = "./modules/app_server"

  for_each = local.servers

  name                   = each.value
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.kijanikiosk_sg.id]
  key_name               = var.key_name
  tags = {
    Name = each.value
    Role = each.key
  }
}
