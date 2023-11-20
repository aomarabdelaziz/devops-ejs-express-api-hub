output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "aws_eks_node_group_id" {
  value = aws_eks_node_group.backend.id
}
