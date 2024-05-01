variable "project" {
    type = string
}

variable "name" {
    type = string
}

variable "image" {
    type = string
}

variable "cluster_id" {
    type = string
}

variable "alb_arn" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "memory" {
    type = number
    default = 512
}