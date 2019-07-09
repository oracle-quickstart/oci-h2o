# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# Instructions on that are here: https://github.com/cloud-partners/oci-prerequisites
# ---------------------------------------------------------------------------------------------------------------------

# Required by the OCI Provider
variable "tenancy_ocid" {}

variable "compartment_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

# Key used to SSH to OCI VMs
variable "ssh_public_key" {}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# The defaults here will give you an instance of H2O DAI.  You can also modify these.
# ---------------------------------------------------------------------------------------------------------------------

variable "key" {
  default = ""
  description = "Set to the value of your license key. If empty, you will be prompted to enter your key at first login. Get a trial key: https://www.h2o.ai/try-driverless-ai/"
}

variable "shape" {
  default = "VM.GPU3.1"
  description = "Instance shape to deploy."
}

variable "ad_number" {
  default = 1
  description = "Which availability domain to deploy to depending on quota, zero based."
}

variable "disk_size_gb" {
  default = 0
  description = "Size of block volume in GB for data, min 50. If set to 0 volume will not be created/mounted."
}

variable "user" {
  default = "admin"
  description = "Default login user."
}

variable "password" {
  default = "admin"
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

# Not used for normal terraform apply, added for marketplace deployments.

variable "mp_listing_resource_id" {
  default = ""
}


# Both GPU and non-GPU platform images
#
# https://docs.cloud.oracle.com/iaas/images/image/0693e672-c5b9-43ce-821e-dfd918366be9/
# Oracle-Linux-7.6-Gen2-GPU-2019.03.22-1
# https://docs.cloud.oracle.com/iaas/images/image/2c504562-5b82-427a-b72f-6122fa9d9a21/
# Oracle-Linux-7.6-2019.03.22-1

variable "platform-images" {
  type = "map"

  default = {
    ca-toronto-1-gpu   = "ocid1.image.oc1.ca-toronto-1.aaaaaaaa2qu5d42l6wubijavqic26kspjyvi6kn25oiop4di633kcd6e4oeq"
    eu-frankfurt-1-gpu = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaafn5eqdsiraw5rhxfqbf7hizx5dhur4ffmvvpjtx7pew7nqdiux5q"
    uk-london-1-gpu    = "ocid1.image.oc1.uk-london-1.aaaaaaaa4ra77q7sgfgtknxaeef34z2ezjqt6onv6akifberbibfwhpjddna"
    us-ashburn-1-gpu   = "ocid1.image.oc1.iad.aaaaaaaamg5ew5ymoilp3r3pzgo4pcoajicqavjv7q5bnyd4tibggcwupula"
    us-phoenix-1-gpu   = "ocid1.image.oc1.phx.aaaaaaaaiza335ab5niqcjscm5yithovegaxzsipmchrujez7gk4ij5pjqvq"
    ca-toronto-1       = "ocid1.image.oc1.ca-toronto-1.aaaaaaaaqopv4wgbh54jrqoa4bjpkng2y2npzoe2jaj5pdne37ljdxbbbdka"
    eu-frankfurt-1     = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa2n5z4nmkqjf27btkbdibflwvximz5i3rsz57c3gowckozrdshnua"
    uk-london-1        = "ocid1.image.oc1.uk-london-1.aaaaaaaaaxnnrqke453ur5katouvfn2i6oweuwpixx6mm5e4nqtci7oztx5a"
    us-ashburn-1       = "ocid1.image.oc1.iad.aaaaaaaavxqdkuyamlnrdo3q7qa7q3tsd6vnyrxjy3nmdbpv7fs7um53zh5q"
    us-phoenix-1       = "ocid1.image.oc1.phx.aaaaaaaapxvrtwbpgy3lchk2usn462ekarljwg4zou2acmundxlkzdty4bjq"
  }
}
