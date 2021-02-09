# Local variables pointing to the Marketplace catalog resource
# Eg. Modify accordingly to your Application/Listing
locals {
  enabled                  = 1
  listing_id               = "ocid1.appcataloglisting.oc1..aaaaaaaaqvaab7wp7j32a7npi2fz5zrfub5izsd6xtfi5pp4wbsg4y7uktja"
  listing_resource_id      = var.image
  listing_resource_version = "1.1"
}

# Get Image Agreement
resource "oci_core_app_catalog_listing_resource_version_agreement" "mp_image_agreement" {
  listing_id               = local.listing_id
  listing_resource_version = local.listing_resource_version
}

# Accept Terms and Subscribe to the image, placing the image in a particular compartment
resource "oci_core_app_catalog_subscription" "mp_image_subscription" {
  compartment_id           = var.compartment_ocid
  eula_link                = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement.eula_link
  listing_id               = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement.listing_id
  listing_resource_version = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement.listing_resource_version
  oracle_terms_of_use_link = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement.oracle_terms_of_use_link
  signature                = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement.signature
  time_retrieved           = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement.time_retrieved

  timeouts {
    create = "20m"
  }
}

# Gets the partner image subscription
data "oci_core_app_catalog_subscriptions" "mp_image_subscription" {
  compartment_id = var.compartment_ocid
  listing_id     = local.listing_id

  filter {
    name   = "listing_resource_version"
    values = [local.listing_resource_version]
  }
}
