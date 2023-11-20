module "ec2" {
  source            = "../ec2"
  vpc_id            = module.network-module.vpc_id
  instances         = ["ansible"]
  instance_type     = "t2.micro"
  avail_zone        = "us-east-1a"
  key-name          = module.keypairs-module.master-key-name
  key-pem           = module.keypairs-module.master-private-key-pem
  subnet_id         = module.network-module.az_subnets_ids[0]
  env_prefix        = "dev"
  eks_cluster_id    = module.eks.eks_cluster_id
  eks_node_group_id = module.eks.aws_eks_node_group_id
  security_groups = {
    "sg1" = {
      name        = "Instance SSH SG"
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
    },
    "sg2" = {
      name        = "Instance HTTP(8080) SG"
      description = "Allow HTTP(8080) inbound traffic"
      ingress = [
        {
          from_port   = 8080
          to_port     = 8080
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




}
