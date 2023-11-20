variable "subnet_ids" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

variable "env_prefix" {
  type = string

}


variable "AmazonEKSClusterPolicy" {
  type = string
}

variable "AmazonEKSServicePolicy" {
  type = string
}


variable "AmazonEKSVPCResourceController" {
  type = string
}

variable "AmazonEKSWorkerNodePolicy" {
  type = string
}

variable "AmazonEKS_CNI_Policy" {
  type = string
}

variable "AmazonEC2ContainerRegistryFullAccessWorker" {
  type = string
}

variable "AmazonEC2ContainerRegistryFullAccessMaster" {
  type = string
}

variable "iam_master_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "capacity_type" {
  type = string

}

variable "disk_size" {
  type = number

}

variable "instance_types" {
  type = list(string)

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

