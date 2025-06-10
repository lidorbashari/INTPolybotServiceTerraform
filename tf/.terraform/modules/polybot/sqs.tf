resource "aws_sqs_queue" "terraform_queue" {
  name                      = "lidor_sqs_tf_project"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_dead_letter.arn
    maxReceiveCount     = 4
  })

  tags = {
    Name = "tf-lidor_sqs_project"
    Environment = var.env
    Region = var.region
  }
}

resource "aws_sqs_queue" "terraform_queue_dead_letter" {
  name = "terraform-example-deadletter"
}

