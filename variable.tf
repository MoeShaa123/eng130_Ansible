##

variable "ami-id" {
	default = "ami-0b47105e3d7fc023e"
} 

variable "subnet1-id" {
	default = "10.0.11.0/24"
} 

variable "subnet2-id" {
	default = "10.0.24.0/24"
} 


variable "vpc-id" {
	default = "10.0.0.0/16"
} 

variable "route-id" {
	default = "0.0.0.0/0"
} 