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
    key       = "jJdNPBVnnmRn29CWuVJG59z7JplktGOwm9cTJUAx39QZT84BDDCuNN7a8OqpKSosB8mIiRzO1m5jSB0chRcOyMYk4PPNgF48VBPZk4i9B09aNOPzPY_4ntxznEP3prNrQfQlePFJH9hlNgEOGd9g9r5hpRijdwoLlT811MvDr4ikzK6LUQodOHo5ChIE2KMHxrLgc8MsupBexQuH3Wnv5y01OhU2TTfzh-vkqsCgj3T5abwtxG065FJnHe4Kd5sjBoryMSH2fzCrMmwWduPUt4UYGe3B5thJPUNHVlNXTU0-UKBgQ4DjFQc9DOS3V-jV36DX_Sw3hVxm00QayOaJKGxpY2Vuc2VfdmVyc2lvbjoxCnNlcmlhbF9udW1iZXI6MzM0OTYKbGljZW5zZWVfb3JnYW5pemF0aW9uOk9yYWNsZQpsaWNlbnNlZV9lbWFpbDpvZ3V6LnBhc3Rpcm1hY2lAb3JhY2xlLmNvbQpsaWNlbnNlZV91c2VyX2lkOjMzNDk2CmlzX2gyb19pbnRlcm5hbF91c2U6ZmFsc2UKY3JlYXRlZF9ieV9lbWFpbDprYXlAaDJvLmFpCmNyZWF0aW9uX2RhdGU6MjAxOS8wNC8yOQpwcm9kdWN0OkRyaXZlcmxlc3NBSQpsaWNlbnNlX3R5cGU6dHJpYWwKZXhwaXJhdGlvbl9kYXRlOjIwMTkvMDUvMjAK"

    # Default login user/pw
    user = "admin"
    password = "admin"
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
