
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.iam_master_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    var.AmazonEKSClusterPolicy,
    var.AmazonEKSServicePolicy,
    var.AmazonEKSVPCResourceController,
    var.AmazonEC2ContainerRegistryFullAccessMaster
  ]

}

resource "aws_eks_node_group" "backend" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.env_prefix
  node_role_arn   = var.iam_master_arn
  subnet_ids      = var.subnet_ids
  capacity_type   = var.capacity_type
  disk_size       = var.disk_size
  instance_types  = var.instance_types
  remote_access {
    ec2_ssh_key               = "master-key"
    source_security_group_ids = values(aws_security_group.worker_node_sg)[*].id
  }

  labels = tomap({ env = var.env_prefix, name = "backend-worker" }) # Add a label for the worker nodes

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    var.AmazonEKSWorkerNodePolicy,
    var.AmazonEKS_CNI_Policy,
    var.AmazonEC2ContainerRegistryFullAccessWorker,
  ]

  tags = {
    Name = "${var.env_prefix}-backend-worker",
  }

}

resource "aws_security_group" "worker_node_sg" {
  for_each = var.security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = each.value.ingress

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egress

    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}
