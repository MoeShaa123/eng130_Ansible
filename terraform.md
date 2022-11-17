## Terraform

Terraform is an open-source infrastructure as code software tool owned by HashiCorp that enables you to safely and predictably create, change, and improve infrastructure.
Terraform is an IAC tool, used primarily by DevOps teams to automate various infrastructure tasks. 

One of the main functions of Terraform is for public cloud provisioning on one of the major providers. Providing an IaC for services such as AWS and Azure has -- and will continue to be -- the main focus of Terraform.
Terraform is used to facilitate multi-cloud deployments. One of the main draws of Terraform is that it performs across all cloud providers simultaneously, unlike some of its other IaC competitors. 

- Speed and Simplicity. IaC eliminates manual processes, thereby accelerating the delivery and management lifecycles. IaC makes it possible to spin up an entire infrastructure architecture by simply running a script.
- Team Collaboration. Various team members can collaborate on IaC software in the same way they would with regular application code through tools like Github. Code can be easily linked to issue tracking systems for future use and reference.
- Error Reduction. IaC minimizes the probability of errors or deviations when provisioning your infrastructure. The code completely standardizes your setup, allowing applications to run smoothly and error-free without the constant need for admin oversight.
- Disaster Recovery. With IaC you can actually recover from disasters more rapidly. Because manually constructed infrastructure needs to be manually rebuilt. But with IaC, you can usually just re-run scripts and have the exact same software provisioned again.
- Enhanced Security. IaC relies on automation that removes many security risks associated with human error. When an IaC-based solution is installed correctly, the overall security of your computing architecture and associated data improves massively.

```
# write a script to launch resources on the cloud

# create ec2 instance on AWS

# download dependencies from AWS

provider "aws" {

# which part of AWS we would like to launch resouces in
  region = "eu-west-1"
}

resource "aws_instance" "app_instance" {
  ami         = "ami-0b47105e3d7fc023e"
  instance_type = "t2.micro"
  associate_public_ip_address = true
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

```
