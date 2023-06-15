# Configure AWS provider
provider "aws" {
  region = "ap-south-1"  # Replace with your desired region
}

# Create security group for EC2 instance
resource "aws_security_group" "instance_sg1" {
  name        = "instance-sg1"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your desired source IP range
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
    Name = "instance-sg1"
  }
}

# Create EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-057752b3f1d6c4d6c"  # Replace with your desired AMI ID
  instance_type = "t2.micro"  # Replace with your desired instance type

  user_data = <<-EOF
#!/bin/bash
docker run -d -p 80:80 nginx:latest
EOF

  vpc_security_group_ids = [aws_security_group.instance_sg1.id]

  tags = {
    Name = "nginx-exam"
  }
}
