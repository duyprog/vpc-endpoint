variable "region" {
  type        = string
  description = "region"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private Subnet List"
}

variable "cidr_block" {
  type        = string
  description = "Cidr block of VPC"
}

variable "vpc_id" {
  type        = string
  description = "id of VPC"
}