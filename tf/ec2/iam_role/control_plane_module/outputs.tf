output "control_plane_instance_profile_name" {
  description = "The name of the IAM instance profile for the control plane."
  value       = aws_iam_instance_profile.control_plane_profile.name
}

output "control_plane_security_group" {
  description = "the security group for control plane"
  value = aws_security_group.lidor-sg-control-plane-tf.id
}