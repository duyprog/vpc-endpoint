variable "subnet_id" {
  type        = string
  description = "The subnet that we will place ec2 instance"
}

variable "vpc_id" {
  type        = string
  description = "The VPC that we will place ec2 instance"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR of VPC"
}