locals {
  ad = var.ad_number
}

resource "oci_core_instance" "h2o" {
  display_name        = "h2o"
  compartment_id      = var.compartment_ocid
  availability_domain = local.ad
  shape               = var.shape

  source_details {
    source_id   = var.image
    source_type = "image"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    hostname_label   = "h2o"
    display_name     = "h2o"
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(
      join(
        "\n",
        [
          "#!/usr/bin/env bash",
          "DEFAULT_USER=\"${var.user}\"",
          "DEFAULT_PW=\"${var.password}\"",
          "DISK_COUNT=\"${var.disk_size_gb >= 50 ? 1 : 0}\"",
          file("./scripts/node.sh"),
        ],
      ),
    )
  }
}

data "oci_core_vnic_attachments" "h2o_vnic_attachments" {
  compartment_id      = var.compartment_ocid
  availability_domain = local.ad
  instance_id         = oci_core_instance.h2o.id
}

data "oci_core_vnic" "h2o_vnic" {
  vnic_id = data.oci_core_vnic_attachments.h2o_vnic_attachments.vnic_attachments[0]["vnic_id"]
}

resource "oci_core_volume" "h2o" {
  availability_domain = local.ad
  compartment_id      = var.compartment_ocid
  display_name        = "h2o"
  size_in_gbs         = var.disk_size_gb
}

resource "oci_core_volume_attachment" "h2o" {
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.h2o.id
  volume_id       = oci_core_volume.h2o.id
}

output "Driverless_AI_URL" {
  value = "https://${oci_core_instance.h2o.public_ip}:12345"
}
