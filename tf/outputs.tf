output "ami_id" {
  description = "ami id of chosen region"
  value = data.aws_ami.ubuntu.id
}