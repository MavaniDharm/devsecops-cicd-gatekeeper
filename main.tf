provider "aws" {
  region = "ap-south-1"
}

resource "aws_kms_key" "s3" {
  description         = "S3 encryption key"
  enable_key_rotation = true
}

resource "aws_s3_bucket" "logs" {
  bucket = "devsecops-demo-logs-12345"
}

resource "aws_s3_bucket" "demo" {
  bucket = "devsecops-demo-bucket-12345"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }
  }
}

resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "demo" {
  bucket        = aws_s3_bucket.demo.id
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_public_access_block" "demo" {
  bucket                  = aws_s3_bucket.demo.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_security_group" "ssh_restricted" {
  name        = "ssh-restricted"
  description = "SSH from office IP only"

  ingress {
    description = "SSH from trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.10/32"]
  }
}
