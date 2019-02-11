# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# Instructions on that are here: https://github.com/cloud-partners/oci-prerequisites
# ---------------------------------------------------------------------------------------------------------------------

# Required by the OCI Provider
variable "tenancy_ocid" {}
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
    shape = "BM.GPU2.2"
    node_count = 1
    key = "noJb1_jEkvKarr44loaBM-uiQZtj-NA-KRcjV-0KPZf8tecSdg0mlvoVdBO13YV5inGOQY01cBJ3RPcTF9boFvcwvnwwOkV3OWc3oJFXFFUslkPA8I-Z1KrBS1DJPz89Z7Pffoz634hgczp_vYJ5H4Dur4dJqjpfDc5E-Q1Jj1lvLscGqGtZGqOBTQgAwyS1wJ-8OGzTxHojrmA3Dzc5uwkWwQp4v4R1fCJyKtIzIosb5cJnqjh4sKxuaPpOgxRo8IQtc8M7LZuZuP3r7MhsmjA0hBPB-ohtKALoHV5E9lnes0cqlGIlinWxgqc84vtGylUKG3CuUhVTQLxLBO7VaGxpY2Vuc2VfdmVyc2lvbjoxCnNlcmlhbF9udW1iZXI6MzA4MzYKbGljZW5zZWVfb3JnYW5pemF0aW9uOk9yYWNsZQpsaWNlbnNlZV9lbWFpbDpiZW50b24ubGFja2V5QGdtYWlsLmNvbQpsaWNlbnNlZV91c2VyX2lkOjMwODM2CmlzX2gyb19pbnRlcm5hbF91c2U6ZmFsc2UKY3JlYXRlZF9ieV9lbWFpbDprYXlAaDJvLmFpCmNyZWF0aW9uX2RhdGU6MjAxOS8wMi8xMQpwcm9kdWN0OkRyaXZlcmxlc3NBSQpsaWNlbnNlX3R5cGU6dHJpYWwKZXhwaXJhdGlvbl9kYXRlOjIwMTkvMDMvMDQK"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Constants
# You probably don't need to change these.
# ---------------------------------------------------------------------------------------------------------------------

// https://docs.cloud.oracle.com/iaas/images/image/e4de7fce-d505-4c4c-a94a-0e9a72f3a259/
// Oracle-Linux-7.5-Gen2-GPU-2018.08.14-0
variable "images" {
  type = "map"
  default = {
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaimxelxqd3s77m3wsu7argbasbp2mz35qei7xiu6gqb3uf57ywnaa"
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaapq5wdwd7y2c57iqi3vduixk7oxwduni5cbtjmeskocg5thrlqo5a"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaai66gcuvoue5zblvogi7mvi7lomgxm6nat6mck7uumvmsz5gmpg7q"
    uk-london-1  = "ocid1.image.oc1.uk-london-1.aaaaaaaao4bkg34ku4ok5pqr4i3dxlath267ge47yh46ctqfjjuigde3m5qa"
  }
}
