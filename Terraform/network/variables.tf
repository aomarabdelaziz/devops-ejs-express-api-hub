variable "vpc_cidr_block" {
  type = string
}

variable "subnets_az" {
  type = list(string)
}

variable "env_prefix" {
  type = string

}
