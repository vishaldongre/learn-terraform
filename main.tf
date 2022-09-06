provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "instance" {
  name   = "terraform-example-sg"
  vpc_id = "vpc-00df0f947cc2a9a6a"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"

  user_data                   = <<-EOF
              #!/bin/bash
              echo "Hello Universe" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  user_data_replace_on_change = true
  vpc_security_group_ids      = [aws_security_group.instance.id]

  tags = {
    "Name" = "terraform-example"
  }
}
