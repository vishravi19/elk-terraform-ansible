data "google_kms_key_ring" "keyring" {
  count    = var.cmek_key_exists ? 1 : 0
  project  = var.project_id
  name     = var.cmek_keyring_name
  location = var.cmek_location
}

data "google_kms_crypto_key" "key" {
  count    = var.cmek_key_exists ? 1 : 0
  name     = var.cmek_key_name
  key_ring = data.google_kms_key_ring.keyring[0].id
}