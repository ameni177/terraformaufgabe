resource "aws_instance" "main" {
  ami                         = "ami-0084a47cc718c111a"
  instance_type               = "t2.small"
  subnet_id                   = aws_subnet.main_a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.main.id]
  key_name                    = "NEW"

  user_data = file("init.sh")

#   user_data = <<-EOL
#             #!/bin/bash
#             sudo apt install nginx -y
#             EOL

  tags = {
    Name = "Hello From Terraform"
  }
}

resource "aws_security_group" "main" {
  name   = "nginx-webserver"
  vpc_id = aws_vpc.main.id

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
  tags = {
    Name = "Hello From Terraform"
  }
}


output "ec2_public_ip" {
  value       = format("Webseite @ http://%s", aws_lb.main.dns_name)
  description = "Öffentliche IP-Adresse der EC2-Instanz"
}