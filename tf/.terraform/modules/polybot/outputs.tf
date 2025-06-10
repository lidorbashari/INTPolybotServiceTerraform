output "sqs_arn" {
  description = "arn of sqs"
  value = aws_sqs_queue.terraform_queue.arn
}

output "s3_name" {
  description = "name of the bucket"
  value = aws_s3_bucket.polybot-tf-bucket.id
}