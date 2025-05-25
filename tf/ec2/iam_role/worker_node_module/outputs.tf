output "worker_node_instance_profile_name" {
  description = "The name of the IAM instance profile for the Worker node."
  value       = aws_iam_instance_profile.worker_node_profile.name
}

output "worker_node_security_group" {
  description = "the security group for worker node"
  value = aws_security_group.lidor-sg-worker-node-tf.id
}