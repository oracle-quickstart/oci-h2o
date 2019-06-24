locals {
  # Used locally to determine the correct platform image. Shape names always
  # start with either 'VM.'/'BM.' and all GPU shapes have 'GPU' as the next characters
  shape_type = "${lower(substr(var.shape,3,3))}"
}

resource "oci_core_instance" "h2o" {
  display_name        = "h2o"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.ad_number],"name")}"
  shape               = "${var.shape}"
  subnet_id           = "${oci_core_subnet.subnet.id}"

  source_details {
    source_id   = "${local.shape_type == "gpu" ? var.platform-images["${var.region}-gpu"] : var.platform-images[var.region]}"
    source_type = "image"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"

    user_data = "${base64encode(join("\n", list(
      "#!/usr/bin/env bash",
      "KEY=${var.key}",
      "DEFAULT_USER=\"${var.user}\"",
      "DEFAULT_PW=\"${var.password}\"",
      "DISK_COUNT=\"${var.diskSizeGB > 0 ? 1 : 0}\"",
      file("../scripts/node.sh")
    )))}"
  }

  count = 1
}

data "oci_core_vnic_attachments" "h2o_vnic_attachments" {
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.ad_number],"name")}"
  instance_id         = "${oci_core_instance.h2o.*.id[0]}"
}

data "oci_core_vnic" "h2o_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.h2o_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}

resource "oci_core_volume" "h2o" {
  count               = "${var.diskSizeGB > 0 ? 1 : 0}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.ad_number],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "h2o"
  size_in_gbs         = "${var.diskSizeGB}"
}

resource "oci_core_volume_attachment" "h2o" {
  count           = "${var.diskSizeGB > 0 ? 1 : 0}"
  attachment_type = "iscsi"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.h2o.*.id[0]}"
  volume_id       = "${oci_core_volume.h2o.*.id[0]}"
}

output "Driverless AI URL" {
  value = "https://${data.oci_core_vnic.h2o_vnic.public_ip_address}:12345"
}
