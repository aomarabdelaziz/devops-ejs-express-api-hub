module "eks" {
  source         = "../eks"
  vpc_id         = module.network-module.vpc_id
  subnet_ids     = module.network-module.az_subnets_ids
  env_prefix     = "dev"
  cluster_name   = "demo-cluster"
  capacity_type  = "ON_DEMAND"
  disk_size      = 20
  instance_types = ["t2.small"]

  security_groups = {
    "sg1" = {
      name        = "eks-sg"
      description = "Allow ssh inbound traffic"
      ingress = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }


  AmazonEKSClusterPolicy                     = module.iam-module.AmazonEKSClusterPolicy
  AmazonEKSServicePolicy                     = module.iam-module.AmazonEKSServicePolicy
  AmazonEKSVPCResourceController             = module.iam-module.AmazonEKSVPCResourceController
  AmazonEKSWorkerNodePolicy                  = module.iam-module.AmazonEKSWorkerNodePolicy
  AmazonEKS_CNI_Policy                       = module.iam-module.AmazonEKS_CNI_Policy
  AmazonEC2ContainerRegistryFullAccessMaster = module.iam-module.AmazonEC2ContainerRegistryFullAccessMaster
  AmazonEC2ContainerRegistryFullAccessWorker = module.iam-module.AmazonEC2ContainerRegistryFullAccessWorker
  iam_master_arn                             = module.iam-module.iam_master_arn


}
