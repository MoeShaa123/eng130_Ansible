# write a script to launch resources on the cloud

# create ec2 instance on AWS

# download dependencies from AWS

provider "aws" {

  # which part of AWS we would like to launch resouces in
  region = "eu-west-1"
}



resource "aws_vpc" "main-vpc" {
  cidr_block       = var.vpc-id
  instance_tenancy = "default"

  tags = {
    Name = "eng130_yusuf_vpc"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main-vpc.id

 
}

resource "aws_route_table" "main-route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = var.route-id
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  
}
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = var.subnet-id
  availability_zone = "eu-west-1a"

  tags = {
    Name = "eng130_yusuf_subnet"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.main-route-table.id
}


resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "eng130_yusuf_sg"
  }
}

resource "aws_instance" "app_instance" {
  ami                         = var.ami-id
  key_name = "eng130"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id =  aws_subnet.subnet-1.id
  tags = {
    Name = "eng130-yusuf-terraform-app"
  }
  
}
# what type of server with what sort of function

# add resource

# ami

# instance type

# do we need public ip or not

# name the server
