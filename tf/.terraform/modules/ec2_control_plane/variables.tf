variable "ami_id" {
  description = "ami_id of the region"
  type = string
}

variable "subnet_id" {
  description = "subnet id of the vpc"
  type = string
}

variable "vpc_id" {
  description = "the id of the vpc"
  type = string
}

variable "env" {
  description = "enviroment's workspace"
  type = string
}

variable "region" {
  description = "region"
  type = string
  default = "us-north-1"
}

variable "key_name" {
  description = "key for ec2"
  type = string
}

variable "worker_nodes_sg_id" {
  description = "Security group ID of the worker nodes"
  type        = string
}