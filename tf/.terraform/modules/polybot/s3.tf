resource "aws_s3_bucket" "polybot-tf-bucket" {
  bucket = "polybot-tf-bucket"

  tags = {
    Name        = "lidor tf bucket"
    Environment = var.env
    region = "eu-north-1"
  }
}