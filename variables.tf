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
  default     = 2
  description = "Which availability domain to deploy to depending on quota, zero based."
}

variable "disk_size_gb" {
  default     = 1000
  description = "Size of block volume in GB for data."
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
# Oracle Linux 8 GPU
# https://docs.oracle.com/en-us/iaas/images/image/aa3d2c46-0636-4bd4-b5e0-0966751a33e7/
# It should be a Marketplace image and would then work with non GPU shapes in all regions.
variable "image" {
  default = "ocid1.image.oc1.iad.aaaaaaaadly6hoipurnavvailrrizvq3sdxlkquw6mmzm7mc2jjburlzrfqa"
}
