resource "aws_security_group" "ssm_sg" {
  name        = "ssm-sg"
  description = "Allow TLS inbound To AWS Systems Manager Session Manager"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    description = "Allow All Egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "ssm" {
  count             = 1
  vpc_id            = var.vpc_id
  subnet_ids        = [element(var.private_subnets, count.index)]
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.ssm_sg.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  count             = 1
  vpc_id            = var.vpc_id
  subnet_ids        = [element(var.private_subnets, count.index)]
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.ssm_sg.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  count             = 1
  vpc_id            = var.vpc_id
  subnet_ids        = [element(var.private_subnets, count.index)]
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.ssm_sg.id
  ]

  private_dns_enabled = true
}

