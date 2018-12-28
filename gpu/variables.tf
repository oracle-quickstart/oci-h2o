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
<<<<<<< HEAD
    key = "aRgbv1OsX69tXfVu7N6WIht9PV-712SfBgjgp6TnF1eDZaxzPME0Ad7ZXvNwFyN_NhstKzM_AcjlkoKsU5hHAlfpwY-7XuNdHQ5dkjNav8aYyo8F9aNWqfdCvmKeIwpgtEoeuqDuxCPE0ZjSk21RqJFl9ZrTz4hG9jzT-D6yCHogK-q4S6CMEN2epVkqARsez2pgr-RQYsMO4_jRjDdz70-M0hA37D_bSwMXzT0IbtObRTeH80uac6P9eyDcHk_PKjf1kVr3wAQkYTlU1hdnTtEMsonqRwq_42IelioluKyKxgiwPeQNu-f6Q1al4nYOgA9mcNXy5cafOScxrqpBO2xpY2Vuc2VfdmVyc2lvbjoxCnNlcmlhbF9udW1iZXI6Mjk1NTYKbGljZW5zZWVfb3JnYW5pemF0aW9uOk5BCmxpY2Vuc2VlX2VtYWlsOmJlbi5sYWNrZXlAb3V0bG9vay5jb20KbGljZW5zZWVfdXNlcl9pZDoyOTU1Ngppc19oMm9faW50ZXJuYWxfdXNlOmZhbHNlCmNyZWF0ZWRfYnlfZW1haWw6a2F5QGgyby5haQpjcmVhdGlvbl9kYXRlOjIwMTgvMTIvMjcKcHJvZHVjdDpEcml2ZXJsZXNzQUkKbGljZW5zZV90eXBlOnRyaWFsCmV4cGlyYXRpb25fZGF0ZToyMDE5LzAxLzE3Cg=="
=======
    key = "mObktdzmllPEOAvB4eDl"
>>>>>>> 1e6760cdaa9afefae39db971340017cda69ebb7a
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
