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
    key = "mObktdzmllPEOAvB4eDl-P7bY4B1zne84J9bisUMOM70uslsDi0yCN3_nZWgO3S4w3dir7v-hzUKD82tNlNHVswsPUQs0IWH5G-kU1YBltCx7V_tyv3GmLA_Wch9NzJSz31ZtIqjJ4e_WrlYlqZ_WwOjnq5KgIalOQYWs-ICskdpxC1v_Jsgic3UNJ0fbKEmOfk-1dkvOEs9p2JdqGUTZv963dNbcYC9W6HWKfuOJ8CYjsghJ-hdVLXq4NrK4pYb73vQiE4zjzIzrvReMDenW8X7CKLyC0kr-h6y8eyN4Y3F4Gv8WFt6DSeBIInF5TVeYidmcQQ6sBbTwbcHB1vx9WxpY2Vuc2VfdmVyc2lvbjoxCnNlcmlhbF9udW1iZXI6MjkwMjUKbGljZW5zZWVfb3JnYW5pemF0aW9uOk9yYWNsZQpsaWNlbnNlZV9lbWFpbDpqb3NlcGgucG9jemF0ZWtAb3JhY2xlLmNvbQpsaWNlbnNlZV91c2VyX2lkOjI5MDI1CmlzX2gyb19pbnRlcm5hbF91c2U6ZmFsc2UKY3JlYXRlZF9ieV9lbWFpbDprYXlAaDJvLmFpCmNyZWF0aW9uX2RhdGU6MjAxOC8xMi8wNQpwcm9kdWN0OkRyaXZlcmxlc3NBSQpsaWNlbnNlX3R5cGU6dHJpYWwKZXhwaXJhdGlvbl9kYXRlOjIwMTgvMTIvMjYK"
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
