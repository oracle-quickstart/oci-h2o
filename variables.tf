# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# Instructions on that are here: https://github.com/oracle-quickstart/oci-prerequisites
# ---------------------------------------------------------------------------------------------------------------------

# Required by the OCI Provider
variable "tenancy_ocid" {
}

variable "compartment_ocid" {
}

variable "region" {
}

# Key used to SSH to OCI VMs
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
  description = "Size of block volume in GB for data, min 50. If set to 0 volume will not be created/mounted."
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

# This is a normal OL 7 image.  Not sure what's going on with this VAR.  CI/CD interaction I suppose....
variable "mp_listing_resource_id" {
  default = "ocid1.image.oc1.iad.aaaaaaaaqdc7jslbtue7abhwvxaq3ihvazfvihhs2rwk2mvciv36v7ux5sda"
}
