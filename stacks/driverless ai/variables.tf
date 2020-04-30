# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables. 
# Instructions on that are here: https://github.com/cloud-partners/oci-prerequisites
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

variable "key" {
  default     = ""
  description = "Set to the value of your license key. If empty, you will be prompted to enter your key at first login. Get a trial key: https://www.h2o.ai/try-driverless-ai/"
}

variable "shape" {
  default     = "VM.GPU3.1"
  description = "Instance shape to deploy."
}

variable "ad_number" {
  default     = 0
  description = "Which availability domain to deploy to depending on quota, zero based."
}

variable "disk_size_gb" {
  default     = 0
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

variable "mp_listing_id" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaaqvaab7wp7j32a7npi2fz5zrfub5izsd6xtfi5pp4wbsg4y7uktja"
}

variable "mp_listing_resource_id" {
  default = "ocid1.image.oc1.iad.aaaaaaaa3nw7aaahc2uhsizbtmrkhtnwiptcwi734jawhlalypoum73lbtlq"
}

variable "mp_listing_resource_version" {
  default = "1.1"
}

variable "use_marketplace_image" {
  default = true
}
