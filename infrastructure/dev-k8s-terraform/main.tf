provider "aws" {
  region = "us-east-1"
}

variable "sec-gr-k8s" {
  default = "petclinic-k8s-sec-group"
}


data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-0f20135223f805def"]  # <-- Burayı kendi VPC'ne göre ayarla (örn. "my-vpc" vs.)
  }
}

resource "aws_security_group" "k8s-sec-gr" {
  name   = var.sec-gr-k8s
  vpc_id = data.aws_vpc.selected.id

  tags = {
    Name = var.sec-gr-k8s
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
