# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get the default subnet in a specific AZ
data "aws_subnet" "default_subnet" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1a"  # Specify your desired AZ
  
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

# Create a security group
resource "aws_security_group" "instance_sg" {
  name_prefix = "instance_sg"
  vpc_id      = data.aws_vpc.default.id

  # Allow inbound SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Instance Security Group"
  }
}

# Create EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0c7217cdde317cfec"  # Latest Amazon Linux 2023 AMI for us-east-1
  instance_type = "t2.micro"
  key_name      = "Amity-us-east-1"

  subnet_id                   = data.aws_subnet.default_subnet.id
  vpc_security_group_ids     = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "MyEC2Instance"
    Environment = "Development"
  }
}

# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

# Output the instance ID
output "instance_id" {
  value = aws_instance.example.id
}
