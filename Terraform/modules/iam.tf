module "iam-module" {
  source         = "../iam"
  cluster-name   = "demo-cluster"
  ansible-ec2-id = module.ec2.ansible_ec2_id

}
