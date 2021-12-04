variable "project_id" {
  type        = string
  description = "The ID of the project in which the resource belongs."
}

variable "name" {
  type        = string
  description = " A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "machine_type" {
  type        = string
  description = "The machine type to create."
}

variable "zone" {
  type        = string
  description = "The zone that the machine should be created in. If it is not provided, the provider zone is used."
}

variable "tags" {
  type        = list(string)
  description = "A list of network tags to attach to the instance."
}

variable "boot_disk" {
  type = object({
    image = string
    type  = string
    size  = string
  })
  description = "Boot disk configuration."
}

variable "network_interface" {
  type = list(object({
    network            = string
    subnetwork         = string
    subnetwork_project = string
  }))
  description = "Networks to attach to the instance. This can be specified multiple times."
}

variable "metadata_startup_script" {
  type        = string
  description = "Path to startup script."
  default     = null
}

variable "ssh_pub_key_path" {
  type        = string
  description = "Path to the SSH Public Key file"
}

variable "ssh_user" {
  type        = string
  description = "Username to login with"
}

variable "num_master_nodes" {
  type        = number
  description = "Number of master nodes to created"
}

variable "num_data_nodes" {
  type        = number
  description = "Number of data nodes to created"
}

# CMEK variables
variable "cmek_key_exists" {
  type        = bool
  description = "Boolean value indicating whether to create a new CMEK key or use the existing key. If `false` then new key will be created else existing key will be retrieved based on variables starting with cmek_"
}

variable "cmek_keyring_name" {
  type        = string
  description = "Name of Keyring resource."
}
variable "cmek_key_name" {
  type        = string
  description = "Name of Key resource"
}
variable "cmek_location" {
  type        = string
  description = "Location where CMEK resources must be created."
}

# Service Account Varibales
variable "account_id" {
  type        = string
  description = "The Google service account ID."
}

variable "service_account_scopes" {
  type        = list(string)
  description = "Configration for new Service Account to be created and attached to the instances."
}