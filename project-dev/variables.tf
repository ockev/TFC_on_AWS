

variable "ami_id" {
  type = string 
  description = "AMI ID for hard coding instance image"
}

variable "zone" {
  type = string
  description = "Availability zone for deployment"
}

variable "env" {
  type = string
  description = "Environment name for templating"
}


variable "vpc_cidr" {
  type = string
  description = "Network block for the VPC"
} 

variable "pub_subnet_cidr" {
  type = string
  description = "Network block for public subnet"
}

variable "pri_subnet_cidr" {
  type = string
  description = "Network block for private subnet"
}

variable "web_server_private_ip" {
  type = string
  description = "web server private ip"
}

variable "app_server_private_ip" {
  type = string
  description = "app server private ip"
}

variable "region" {
  type = string
  description = "region for deployment"
}