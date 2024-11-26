# AWS Region
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string

}

# VPC CIDR Block
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string

}

# Availability Zones
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)

}
# Define variables for instance names
variable "instance_names" {
  description = "List of instance names"
  default     = ["master", "slave"]
}

# AMI ID
variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

# Instance Type
variable "instance_type" {
  description = "The type of instance to create"
  type        = string

}
variable "Master-servers" {
  type = list(any)

}

variable "vpc_name" {}
variable "igw_name" {}
variable "public-route-table" {}
variable "public-subnet" {}
variable "SG_allow-ssh" {}

variable "key_name" {
  description = "Existing key pair name"
  default     = "Main-Practice-keypair" # Correct key pair name without .pem extension
}

