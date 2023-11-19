variable "vpc_id" {
  type = string
}

variable "instances" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "avail_zone" {
  type = string
}

variable "key-name" {
  type = string
}

variable "key-pem" {
  type = string
}

variable "env_prefix" {
  type = string
}

variable "subnet_id" {
  type = string
}



variable "security_groups" {
  type = map(object({
    name        = string
    description = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}
