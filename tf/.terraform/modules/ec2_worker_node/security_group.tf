resource "aws_security_group" "lidor-sg-worker-node-tf" {
  name        = "lidor-sg-worker-node-tf"
  description = "Worker Node SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

    ingress {
  from_port   = 0
  to_port     = 0
  protocol    = "4"
  cidr_blocks = ["10.0.0.0/16"]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}