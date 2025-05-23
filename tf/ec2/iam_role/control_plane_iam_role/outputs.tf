output "control_plane_instance_profile_name" {
  description = "The name of the IAM instance profile for the control plane."
  value       = aws_iam_instance_profile.control_plane_profile.name
}