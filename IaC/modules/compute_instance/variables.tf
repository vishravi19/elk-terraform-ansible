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
    kms_key_self_link = string
    image             = string
    type              = string
    size              = string
  })
  description = "Doot disk configuration. "
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

variable "service_account" {
  type = object({
    email  = string
    scopes = list(string)
  })
  description = "Configration for new Service Account to be created and attached to the instances."
}

variable "node_type" {
  type        = string
  description = "Type of node, either master or data"
}

variable "ssh_pub_key_path" {
  type        = string
  description = "Path to the SSH Public Key file"
}

variable "ssh_user" {
  type        = string
  description = "Username to login with"
}