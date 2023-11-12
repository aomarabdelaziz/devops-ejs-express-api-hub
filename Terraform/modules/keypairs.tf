module "keypairs-module" {
  source          = "../keypairs"
  key-pairs-names = ["master-key"]
}
