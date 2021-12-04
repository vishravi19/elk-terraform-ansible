locals {
  boot_disk       = merge(var.boot_disk, { "kms_key_self_link" = var.cmek_key_exists ? data.google_kms_crypto_key.key[0].id : module.cmek[0].cmek_id })
  service_account = { "email" = module.service_account.email, "scopes" = var.service_account_scopes }
}