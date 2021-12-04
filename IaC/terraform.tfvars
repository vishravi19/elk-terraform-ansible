project_id   = ""
name         = ""
machine_type = ""
zone         = ""
# Network tag: one of the tag must match with the firewall rule created to allow communication between nodes.
tags         = [""]
# image: Run `gcloud compute images list` to get list of images. Refer https://cloud.google.com/compute/docs/images for more details.
# type : accepted values are `pd-standard`, `pd-balanced` or `pd-ssd`.
boot_disk = {
  image = ""
  size  = ""
  type  = ""
}
# The name or self_link of the network to attach this interface to.
# Either network or subnetwork must be provided. If network isn't provided it will be inferred from the subnetwork.
# NOTE:
#   * Use `network` field for default and auto-mode network
#   * Use `subnetwork` field for custom-mode network. Provide network=null in this case.
#   * `subnetwork_project` must be supplied when using custom-mode network.
network_interface = [{
  network            = ""
  subnetwork         = ""
  subnetwork_project = ""
}]
metadata_startup_script = null
ssh_pub_key_path        = ""
ssh_user                = ""
num_master_nodes        = 1
num_data_nodes          = 1
# Provide `cmek_key_exists` false to create a new CMEK 
cmek_key_exists         = true
cmek_keyring_name       = ""
cmek_key_name           = ""
# `cmek_location` must be same as the location where instance(s) are being deployed.
cmek_location           = ""
# Account ID of new Service Account to be created
account_id              = ""
service_account_scopes  = [""]
