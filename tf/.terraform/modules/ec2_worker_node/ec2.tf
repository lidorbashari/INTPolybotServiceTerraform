resource "aws_instance" "worker_node" {
  ami = var.ami_id
  instance_type = "t3.medium"
  key_name = var.key_name
  subnet_id = var.subnet_id
  iam_instance_profile = aws_iam_instance_profile.worker_node_profile.name
  vpc_security_group_ids = [aws_security_group.lidor-sg-worker-node-tf.id]
  user_data = file("${path.module}/worker_node_user_data.sh")
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  tags = {
    Name = "tf-lidor_worker_node_project"
    Environment = var.env
    Region = var.region
  }
}
