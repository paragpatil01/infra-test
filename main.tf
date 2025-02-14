provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI (Check for latest AMI ID)
  instance_type = "t2.micro"
  key_name      = "Amity-us-east-1"

  subnet_id = data.aws_subnet.default_subnet.id
  security_groups = ["default"]

  tags = {
    Name = "MyEC2Instance"
  }
}

data "aws_subnet" "default_subnet" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}
