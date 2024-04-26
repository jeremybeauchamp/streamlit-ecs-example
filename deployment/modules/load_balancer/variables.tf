variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "port" {
  type    = number
  default = 80
}

variable "vpc_id" {
  type = string
}