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
  cidr_block = var.subnet1-id
  availability_zone = "eu-west-1a"

  tags = {
    Name = "eng130_yusuf_subnet1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = var.subnet2-id
  availability_zone = "eu-west-1b"

  tags = {
    Name = "eng130_yusuf_subnet2"
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

# resource "aws_instance" "app_instance" {
#   ami                         = var.ami-id
#   key_name = "eng130-new"
#   instance_type               = "t2.micro"
#   associate_public_ip_address = true
#   vpc_security_group_ids = [aws_security_group.allow_web.id]
#   subnet_id =  aws_subnet.subnet-1.id
#   tags = {
#     Name = "eng130-yusuf-terraform-app"
#   }
  
# }

resource "aws_launch_template" "tf-launch-template"{
    name = "eng130_yusuf_lt"
    image_id = var.ami-id
    instance_type = "t2.micro"
    key_name = "eng130-new"
    vpc_security_group_ids = [aws_security_group.allow_web.id] # Don't use this one, Create a new one.
    # user_data = "${base64encode(data.template_file.user_data_lw.rendered)}"
    tags = {
        Name = "eng130_yusuf_lt"
    }
}
resource "aws_autoscaling_group" "tf-asg"{
    name = "eng130_yusuf_terraform_asg"
    desired_capacity = 2
    max_size = 3
    min_size = 2
    vpc_zone_identifier = [aws_subnet.subnet-1.id]

    tag {
      key = "Name"
      propagate_at_launch = true
      value = "eng130_yusuf_terraform"
    }

    launch_template {
      id = aws_launch_template.tf-launch-template.id 
    }
}

resource "aws_lb" "app-lb" {
  name = "eng130-yusuf-terraform-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.allow_web.id]
  subnets = [
    aws_subnet.subnet-1.id,
    aws_subnet.subnet-2.id
  ]
}

