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
# The defaults here will give you a cluster.  You can also modify these.
# ---------------------------------------------------------------------------------------------------------------------

variable "h2o" {
  type = "map"

  default = {
    shape      = "BM.GPU2.2"
    node_count = 1

    # Which availability domain to deploy to depending on quota, zero based
    ad_number = 1
    key       = "K1fRDabPJk_07hGhVE7OWtztFBFn-By_qNOT5eEUB6yKVUj5KTqGopv9_-oYsLv7cO1TGh1XqzY5_Lo9zHGAKUcNx8RPoT1hOrV75ZkxZSEVRaa-Ix-Uu9PVgEJ4E63fW_x4Fx7DFLfFnzMmMIwxGkpyQOHDuqPQe2jOwIsdZBRnQm_cfDtZnoDvndsswNzdL-sDPaLYrLdxzKoVCRdvH6UJO0mRFIGwwHIjb5dmxTT277jwwGn3HM-3PM2xTd_iuUTb_m9aqyWJJa3yp1yspVph8xPBs6_K8xLNK2j6k9vwchGRvYyYzE8Id4MPnQG8vZdQut0VktJcGUoCQrl0VmxpY2Vuc2VfdmVyc2lvbjoxCnNlcmlhbF9udW1iZXI6MzE3ODgKbGljZW5zZWVfb3JnYW5pemF0aW9uOk9yYWNsZSBDb3Jwb3JhdGlvbgpsaWNlbnNlZV9lbWFpbDpiZW4ubGFja2V5QG9yYWNsZS5jb20KbGljZW5zZWVfdXNlcl9pZDozMTc4OAppc19oMm9faW50ZXJuYWxfdXNlOmZhbHNlCmNyZWF0ZWRfYnlfZW1haWw6YWoua3Jlc2hvY2tAaDJvLmFpCmNyZWF0aW9uX2RhdGU6MjAxOS8wMy8xMwpwcm9kdWN0OkRyaXZlcmxlc3NBSQpsaWNlbnNlX3R5cGU6cGlsb3QKZXhwaXJhdGlvbl9kYXRlOjIwMTkvMDQvMzAK"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Constants
# You probably don't need to change these.
# ---------------------------------------------------------------------------------------------------------------------

# Both GPU and non-GPU platform images
#
# https://docs.cloud.oracle.com/iaas/images/image/0693e672-c5b9-43ce-821e-dfd918366be9/
# Oracle-Linux-7.6-Gen2-GPU-2019.03.22-1
# https://docs.cloud.oracle.com/iaas/images/image/2c504562-5b82-427a-b72f-6122fa9d9a21/
# Oracle-Linux-7.6-2019.03.22-1

variable "images" {
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
