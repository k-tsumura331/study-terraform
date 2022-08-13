variable "instance_type" {}

data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*-x86_64-gp2"]
  }
}

resource "aws_instance" "default" {
  ami                    = data.aws_ami.recent_amazon_linux_2.image_id
  vpc_security_group_ids = [aws_security_group.default.id]
  instance_type          = var.instance_type

  user_data = file("./user_data.sh")

  tags = {
    Name    = "default"
    project = "terraform"
  }
}

resource "aws_security_group" "default" {
  name = "ec2"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "default"
    project = "terraform"
  }
}

output "public_dns" {
  value = aws_instance.default.public_dns
}
