
resource "aws_security_group" "lidor-sg-control-plane-tf" {
  name        = "lidor-sg-control-plane-tf"
  description = "Control Plane SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
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

resource "aws_security_group_rule" "allow_all_from_workers" {
  type                     = "ingress"
  from_port               = 0
  to_port                 = 65535
  protocol                = "tcp"
  security_group_id        = aws_security_group.lidor-sg-control-plane-tf.id
  source_security_group_id = var.worker_nodes_sg_id
}
