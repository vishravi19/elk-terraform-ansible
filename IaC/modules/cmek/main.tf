resource "google_kms_key_ring" "keyring" {
  project  = var.project_id
  name     = var.cmek_keyring_name
  location = var.cmek_location
}

resource "google_kms_crypto_key" "key" {
  name     = var.cmek_key_name
  key_ring = google_kms_key_ring.keyring.id
  purpose  = "ENCRYPT_DECRYPT"
}