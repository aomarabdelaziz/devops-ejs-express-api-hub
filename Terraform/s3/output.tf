locals {
  application_filename = basename(var.files_to_upload[0])

}

output "application-chart-url" {
  value = "https://${aws_s3_bucket.helm-bucket.id}.s3.amazonaws.com/${local.application_filename}"
}

output "s3_bucket_objects_ids" {
  value = aws_s3_object.object[*].id
}


