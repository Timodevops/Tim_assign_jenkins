# Configure the AWS provider
provider "aws" {
  region = "us-east-2" # Replace with your desired AWS region
}

# Create the VPC, subnets, internet gateway, and availability zones
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc-1"
  }
}

resource "aws_vpc" "my_vpc" {
    cidr_block = "10.1.0.0/16"

  tags = {
    Name = "my-vpc-2"
  }
}


resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.my_vpc-1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "subnet_1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.my_vpc-2.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "subnet_2"
  }
}

resource "aws_internet_gateway" "my_igw-1" {
  vpc_id = aws_vpc.my_vpc-1.id

  tags = {
    Name = "my-igw-1"
  }
}
resource "aws_internet_gateway" "my_igw-2" {
  vpc_id = aws_vpc.my_vpc-2.id

  tags = {
    Name = "my-igw-2"
  }
}


# Create 3 EC2 instances
resource "aws_instance" "my_ec2-1" {
  ami           = "ami-0bb84b8ffd87024d8" # Replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_1.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  tags = {
    Name = "my-ec2-1"
  }
}
resource "aws_instance" "my_ec2-2" {
  ami           = "ami-04ff98ccbfa41c9ad" # Replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_2.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  tags = {
    Name = "my-ec2-2"
  }
}


# Create a security group
resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  vpc_id      = aws_vpc.my_vpc-1.id # Replace with the desired VPC ID

  # Allow ICMP traffic
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "my_security_group"
  }
}
