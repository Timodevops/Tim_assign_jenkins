# Define the provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Main VPC"
  }
}

# Create two public subnets in different availability zones
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Replace with your desired availability zone

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b" # Replace with your desired availability zone

  tags = {
    Name = "Public Subnet 2"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main Internet Gateway"
  }
}

# Create a route table for the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

# Create an S3 bucket
resource "aws_s3_bucket" "main" {
  bucket = "tf-timoec2" # Replace with your desired bucket name
  acl    = "private"

  tags = {
    Name = "Main S3 Bucket"
  }
}

# Create a load balancer
resource "aws_lb" "main" {
  name               = "main-lb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  security_groups    = [aws_security_group.lb.id]
}

# Create a security group for the load balancer
resource "aws_security_group" "lb" {
  name        = "Load Balancer Security Group"
  description = "Allow inbound HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.main.id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance in each public subnet
resource "aws_instance" "web_server_1" {
  ami           = "ami-02aead0a55359d6ec" # Replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id

  vpc_security_group_ids = [
    aws_security_group.web_server.id,
  ]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p 80 &
              EOF

  tags = {
    Name = "Web Server 1"
  }
}

resource "aws_instance" "web_server_2" {
  ami           = "ami-0e001c9271cf7f3b9" # Replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_2.id

  vpc_security_group_ids = [
    aws_security_group.web_server.id,
  ]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p 80 &
              EOF

  tags = {
    Name = "Web Server 2"
  }
}

# Create a security group for the web servers
resource "aws_security_group" "web_server" {
  name        = "Web Server Security Group"
  description = "Allow inbound HTTP traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a target group for the load balancer
resource "aws_lb_target_group" "main" {
  name        = "main-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

# Register the EC2 instances with the target group
resource "aws_lb_target_group_attachment" "web_server_1" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.web_server_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_server_2" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.web_server_2.id
  port             = 80
}

# Create a listener for the load balancer
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
