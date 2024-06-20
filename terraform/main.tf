provider "aws" {
  region = "eu-central-1"
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

variable "AWS_ACCESS_KEY" {
  description = "AWS Access Key"
  type        = string
}

variable "AWS_SECRET_KEY" {
  description = "AWS Secret Key"
  type        = string
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
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

resource "aws_instance" "server" {
  count         = 2
  ami           = "ami-0faab6bdbac9486fb"
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  user_data = file("${path.module}/cloudinit/meta.yaml")

  tags = {
    Name = "Server-${count.index}"
  }
}

resource "local_file" "vm_ip" {
  content  = join("\n", aws_instance.server.*.public_ip)
  filename = "../ansible/hosts"
}

output "wan_ip" {
  value = aws_instance.server.*.public_ip
}
