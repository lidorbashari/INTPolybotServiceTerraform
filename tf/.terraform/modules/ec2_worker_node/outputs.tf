output "public_ip" {
  value = aws_instance.worker_node.public_ip
}

output "instance_id" {
  value = aws_instance.worker_node.id
}

output "security_group_id" {
  value = aws_security_group.lidor-sg-worker-node-tf.id
}

output "worker_node_sg_id" {
  value = aws_security_group.lidor-sg-worker-node-tf.id
}
