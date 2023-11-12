
output "AmazonEKSClusterPolicy" {
  value = aws_iam_role_policy_attachment.AmazonEKSClusterPolicy.id
}
output "AmazonEKSServicePolicy" {
  value = aws_iam_role_policy_attachment.AmazonEKSServicePolicy.id
}
output "AmazonEKSVPCResourceController" {
  value = aws_iam_role_policy_attachment.AmazonEKSVPCResourceController.id
}


output "AmazonEKSWorkerNodePolicy" {
  value = aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy.id
}


output "AmazonEKS_CNI_Policy" {
  value = aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy.id
}


output "AmazonEC2ContainerRegistryReadOnly" {
  value = aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly.id
}

output "iam_master_arn" {
  value = aws_iam_role.master.arn
}
