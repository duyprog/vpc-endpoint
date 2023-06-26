variable "system_code" {
  type        = string
  description = "System code of application"
}
variable "env_code" {
  type        = string
  description = "Environment code of application"
}
variable "env" {
  type        = string
  description = "Environment of application"
}
variable "owner" {
  type        = string
  description = "Owner"
}
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for main VPC"
  # default = "10.0.0.0/16"
}


variable "availability_zone" {
  type        = number
  description = "Number of availability zone"
  default     = 2
}


# variable "private_subnets" {
#   type = list(string)
#   description = "List of private subnet for VPC"
# }
