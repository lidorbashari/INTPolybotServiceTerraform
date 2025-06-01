output "ami_id" {
  description = "ami id of chosen region"
  value       = data.aws_ami.ubuntu.id
}

output "control_plane_public_ip" {
  description = "public ip of the machines"
  value = module.control_plane_module.public_ip
}

output "worker_node_public_ip" {
  description = "public ip of the machines"
  value = module.worker_node_module.public_ip
}