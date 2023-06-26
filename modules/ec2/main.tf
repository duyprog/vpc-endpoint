data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ssm_role" {
  name               = "PrivateInstanceRole"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ssm_role_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}

resource "aws_iam_instance_profile" "private_instance_profile" {
  role = aws_iam_role.ssm_role.name
  name = "PrivateInstanceRole"
}

resource "aws_security_group" "private_instance_sg" {
  name   = "default-sg-ghc-devops"
  vpc_id = var.vpc_id
  ingress {
    description = "Allow HTTPS protocol in VPC"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.vpc_cidr_block]
    protocol    = "tcp"
  }

  egress {
    description = "Allow all HTTPS outbound traffic"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }
}

resource "aws_instance" "private_instance" {
  ami                  = "ami-076015d9e4b6b6a0b"
  instance_type        = "t2.micro"
  subnet_id            = var.subnet_id
  iam_instance_profile = aws_iam_instance_profile.private_instance_profile.name
  security_groups      = [aws_security_group.private_instance_sg.id]
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
}


