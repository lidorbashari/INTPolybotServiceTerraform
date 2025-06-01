resource "aws_instance" "control_plane" {
  ami = var.ami_id
  instance_type = "t3.medium"
  key_name = var.key_name
  subnet_id = var.subnet_id
  iam_instance_profile = aws_iam_instance_profile.control_plane_profile.name
  vpc_security_group_ids = [aws_security_group.lidor-sg-control-plane-tf.id]
  user_data = file("${path.module}/control_plane_user_data.sh")
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  tags = {
    Name = "tf-lidor_control_plane_project"
    Environment = var.env
    Region = var.region
  }
}

