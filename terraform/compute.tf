locals {
  # Used locally to determine the correct platform image. Shape names always
  # start with either 'VM.'/'BM.' and all GPU shapes have 'GPU' as the next characters
  shape_type = "${lower(substr(var.h2o["shape"],3,3))}"
}

resource "oci_core_instance" "h2o" {
  display_name        = "h2o"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.h2o["ad_number"]],"name")}"
  shape               = "${var.h2o["shape"]}"
  subnet_id           = "${oci_core_subnet.subnet.id}"

  source_details {
    source_id   = "${local.shape_type == "gpu" ? var.images["${var.region}-gpu"] : var.images[var.region]}"
    source_type = "image"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"

    user_data = "${base64encode(join("\n", list(
      "#!/usr/bin/env bash",
      "KEY=${var.h2o["key"]}",
      "DEFAULT_USER=\"${var.h2o["user"]}\"",
      "DEFAULT_PW=\"${var.h2o["password"]}\"",
      file("../scripts/node.sh")
    )))}"
  }

  count = "${var.h2o["node_count"]}"
}

data "oci_core_vnic_attachments" "h2o_vnic_attachments" {
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.h2o["ad_number"]],"name")}"
  instance_id         = "${oci_core_instance.h2o.*.id[0]}"
}

data "oci_core_vnic" "h2o_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.h2o_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}

output "Driverless AI URL" {
  value = "https://${data.oci_core_vnic.h2o_vnic.public_ip_address}:12345"
}
