resource "aws_s3_bucket" "vpc-endpoint-testing" {
  bucket        = "vpc-endpoint-testing"
  bucket_prefix = "${var.system_code}-${var.env_code}-"
}