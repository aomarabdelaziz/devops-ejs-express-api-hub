module "s3-module" {
  source          = "../s3"
  files_to_upload = ["../Helm/express-app-chart-0.0.1.tgz"]

}
