# devsecops-cicd-gatekeeper
provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "demo" {
  bucket = "devsecops-demo-bucket-12345"
}

resource "aws_security_group" "ssh_open" {
  name        = "ssh-open"
  description = "Insecure SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
