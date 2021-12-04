resource "google_compute_instance" "default" {
  project      = var.project_id
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  tags = var.tags

  boot_disk {
    kms_key_self_link = var.boot_disk["kms_key_self_link"]
    initialize_params {
      image = var.boot_disk["image"]
      type  = var.boot_disk["type"]
      size  = var.boot_disk["size"]
    }
  }
  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      network            = network_interface.value.network
      subnetwork         = network_interface.value.subnetwork
      subnetwork_project = network_interface.value.subnetwork_project
    }
  }
  metadata_startup_script = var.metadata_startup_script
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account["email"]
    scopes = var.service_account["scopes"]
  }
  allow_stopping_for_update = true

  provisioner "local-exec" {
    command = "echo ${self.network_interface.0.network_ip} >> ${var.node_type}.txt"
  }
  depends_on = [
    google_kms_crypto_key_iam_binding.cmek_iam_binding
  ]
}

# Assign CMEK permissions to Compute Engine Default Service Account
data "google_project" "project" {
  project_id = var.project_id
}

resource "google_kms_crypto_key_iam_binding" "cmek_iam_binding" {
  crypto_key_id = var.boot_disk["kms_key_self_link"]
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members       = ["serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com"]
}
