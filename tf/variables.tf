variable "vpc_azs" {
  description = "The AZs of my netflix app"
  type        = list(string)
}

variable "env" {
  description = "environment of project"
  type        = string
}

variable "region" {
  description = "the region that i workd about"
  type        = string
}

variable "telegram_token" {
  description = "the token of bot"
  type = string
}