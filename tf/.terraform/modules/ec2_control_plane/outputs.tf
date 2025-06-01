output "public_ip" {
  value = aws_instance.control_plane.public_ip
}

output "instance_id" {
  value = aws_instance.control_plane.id
}

output "security_group_id" {
  value = aws_security_group.lidor-sg-control-plane-tf.id
}