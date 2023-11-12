output "master-key-name" {
  value = var.key-pairs-names[0]
}

output "master-private-key-pem" {
  value = tls_private_key.ssh-pk[0].private_key_pem
}
