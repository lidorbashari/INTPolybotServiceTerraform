output "control_plane_public_ip" {
  description = "public ip of the machines"
  value = module.control_plane_module.public_ip
}

output "worker_node_public_ip" {
  description = "public ip of the machines"
  value = module.worker_node_module.public_ip
}

output "sqs_arn" {
  description = "arn of sqs"
  value = module.polybot_resources.sqs_arn
}

output "bucket_name" {
  description = "the name of the bucket"
  value = module.polybot_resources.s3_name
}