variable "project_id" {
  type        = string
  description = "The ID of the project in which the resource belongs."
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