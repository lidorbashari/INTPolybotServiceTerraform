output "worker_node_instance_profile_name" {
  description = "The name of the IAM instance profile for the Worker node."
  value       = aws_iam_instance_profile.worker_node_profile.name
}