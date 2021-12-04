module "es_master_nodes" {
  count                   = var.num_master_nodes
  source                  = "./modules/compute_instance"
  project_id              = var.project_id
  name                    = "${var.name}-master-node-${count.index + 1}"
  machine_type            = var.machine_type
  zone                    = var.zone
  tags                    = var.tags
  boot_disk               = local.boot_disk
  network_interface       = var.network_interface
  metadata_startup_script = var.metadata_startup_script
  ssh_pub_key_path        = var.ssh_pub_key_path
  ssh_user                = var.ssh_user
  service_account         = local.service_account
  node_type               = "master"
  depends_on = [
    module.cmek
  ]
}


module "es_data_nodes" {
  count                   = var.num_data_nodes
  source                  = "./modules/compute_instance"
  project_id              = var.project_id
  name                    = "${var.name}-data-node-${count.index + 1}"
  machine_type            = var.machine_type
  zone                    = var.zone
  tags                    = var.tags
  boot_disk               = local.boot_disk
  network_interface       = var.network_interface
  metadata_startup_script = var.metadata_startup_script
  ssh_pub_key_path        = var.ssh_pub_key_path
  ssh_user                = var.ssh_user
  service_account         = local.service_account
  node_type               = "data"
  depends_on = [
    module.cmek
  ]
}


module "cmek" {
  count             = var.cmek_key_exists ? 0 : 1
  source            = "./modules/cmek"
  project_id        = var.project_id
  cmek_keyring_name = var.cmek_keyring_name
  cmek_key_name     = var.cmek_key_name
  cmek_location     = var.cmek_location
}

module "service_account" {
  source     = "./modules/service_account"
  project_id = var.project_id
  account_id = var.account_id
}