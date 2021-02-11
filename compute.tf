locals {
  # If ad_number is non-negative use it for AD lookup, else use ad_name.
  # Allows for use of ad_number in TF deploys, and ad_name in ORM.
  # Use of max() prevents out of index lookup call.
  ad = var.ad_number >= 0 ? data.oci_identity_availability_domains.availability_domains.availability_domains[max(0, var.ad_number)]["name"] : var.ad_name
}

resource "oci_core_instance" "h2o" {
  display_name        = "h2o"
  compartment_id      = var.compartment_ocid
  availability_domain = local.ad
  shape               = var.shape

  # This is a platform image.
  # OL 7 GPU
  # It should be a Marketplace image.

  source_details {
    source_id   = "ocid1.image.oc1.iad.aaaaaaaax6antvrwkhgmzxncixdxllhsell3vwui3fy6iw2boowxkwiz5xwq"
    source_type = "image"
    boot_volume_size_in_gbs = 1000
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
          "USER=\"${var.user}\"",
          "PASSWORD=\"${var.password}\"",
          file("./node.sh"),
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

output "Driverless_AI_URL" {
  value = "https://${oci_core_instance.h2o.public_ip}:12345"
}
