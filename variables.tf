# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# ---------------------------------------------------------------------------------------------------------------------

variable "tenancy_ocid" {
}

variable "compartment_ocid" {
}

variable "region" {
}

variable "ssh_public_key" {
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# The defaults here will give you an instance of H2O DAI.  You can also modify these.
# ---------------------------------------------------------------------------------------------------------------------

variable "shape" {
  default     = "VM.GPU3.4"
  description = "Instance shape to deploy."
}

variable "ad_number" {
  default     = 0
  description = "Which availability domain to deploy to depending on quota, zero based."
}

variable "user" {
  default     = "admin"
  description = "Default login user."
}

variable "password" {
  default     = "admin"
  description = "Password for default user."
}

# ---------------------------------------------------------------------------------------------------------------------
# Constants
# You probably don't need to change these.
# ---------------------------------------------------------------------------------------------------------------------

# Not used for normal terraform apply, added for ORM deployments.
variable "ad_name" {
  default = ""
}

# This is a platform image.
# OL 8 GPU
# It should be a Marketplace image.
variable "image" {
  default = "ocid1.image.oc1.iad.aaaaaaaadly6hoipurnavvailrrizvq3sdxlkquw6mmzm7mc2jjburlzrfqa"
}
