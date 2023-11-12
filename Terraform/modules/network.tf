module "network-module" {
  source         = "../network"
  vpc_cidr_block = "10.0.0.0/16"
  subnets_az     = ["us-east-1a", "us-east-1b"]
  env_prefix     = "prod"
}
