terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}


resource "aws_security_group" "web-sg" {
  name        = "allow_http/s-ssh"
  description = "Allow HTTP/S, SSH inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name = "allow_http,https,ssh"
  }
}
resource "aws_route53_zone" "primary" {
  name = "itlab.store"
}

resource "aws_key_pair" "terraform-key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "web-server" {
  ami           = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terraform-key.key_name
  security_groups = ["${aws_security_group.web-sg.name}"]
  user_data = <<EOF

    #!/bin/bash

    yum update -y

    yum install httpd -y

    service httpd start

    chkconfig httpd on

    cd /var/www/html

    echo "<html><h1>Hello Cloud Gurus Welcome To My Webpage</h1></html>" > index.html

  EOF

  tags = {
    Name = "WebServerInstance"
  }
}


