resource "oci_core_instance" "h2o" {
  display_name        = "h2o"
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  shape               = "${var.h2o["shape"]}"
  subnet_id           = "${oci_core_subnet.subnet.id}"
  source_details {
    source_id = "${var.images[var.region]}"
  	source_type = "image"
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(format("%s\n%s\n%s\n",
      "#!/usr/bin/env bash",
      "key=${var.h2o["key"]}",
      file("../scripts/node.sh")
    ))}"
  }
  count = "${var.h2o["node_count"]}"
}

data "oci_core_vnic_attachments" "h2o_vnic_attachments" {
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.h2o.*.id[0]}"
}

data "oci_core_vnic" "h2o_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.h2o_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}

output "Driverless AI URL" { value = "http://${data.oci_core_vnic.h2o_vnic.public_ip_address}:12345" }
