resource "aws_instance" "example" {
  ami           = "ami-0ecb2a61303230c9d"
  instance_type = "t3.micro"

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
  tags = {
    Name    = "examaple"
    project = "terraform"
  }

  lifecycle {
    prevent_destroy = false
  }
}
