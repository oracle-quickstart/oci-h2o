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

# Not used for normal terraform apply, added for ORM deployments.
variable "ad_name" {
  default = ""
}

variable "user" {
  default     = "admin"
  description = "Default login user."
}

variable "password" {
  default     = "admin"
  description = "Password for default user."
}
