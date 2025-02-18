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
  region = "eu-north-1"
}

resource "aws_security_group" "sg" {
  name = "terraform-sg"

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

resource "aws_instance" "lab2" {
  ami                    = "ami-07a64b147d3500b6a"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = <<-EOF
                          #!/bin/bash
                          yum update -y
                          yum install docker -y
                          systemctl start docker
                          systemctl enable docker
                          docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --interval 30
                          docker pull maksio003/web-app
                          docker run -d -p 80:80 maksio003/web-app
                          EOF

  tags = {
    Name = "lab2"
  }
}
