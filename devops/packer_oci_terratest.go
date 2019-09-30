package test

import (
        "os"
        "testing"

        "github.com/gruntwork-io/terratest/modules/oci"
        "github.com/gruntwork-io/terratest/modules/packer"
)

// An example of how to test the Packer template in examples/packer-basic-example using Terratest.
func TestPackerOci(t *testing.T) {
        t.Parallel()

        // The Terratest CI environment does not yet have CI creds set up, so we skip these tests for now
        // https://github.com/gruntwork-io/terratest/issues/160
        if os.Getenv("CIRCLECI") != "" {
                t.Skip("The build is running on CircleCI, so skipping OCI tests.")
        }

        compartmentID := "ocid1.compartment.oc1..aaaaaaaakt3k3f7u5iechtmsjp43c63fw7szupdmkqpjeir2covikyjg3wxa"
        baseImageID := "ocid1.image.oc1.iad.aaaaaaaayuihpsm2nfkxztdkottbjtfjqhgod7hfuirt2rqlewxrmdlgg75q"
        availabilityDomain := "newN:US-ASHBURN-AD-2"
        subnetID := "ocid1.subnet.oc1.iad.aaaaaaaa4vcmx2p7ueerd5bwadqahzxjdyxa7pve7enpfdfedspw3py4tq2q"
        //passPhrase := oci.GetPassPhraseFromEnvVar()

        packerOptions := &packer.Options{
                // The path to where the Packer template is located
                Template: "../examples/build.json",

                // Variables to pass to our Packer build using -var options
                Vars: map[string]string{
                        "oci_compartment_ocid":    compartmentID,
                        "oci_base_image_ocid":     baseImageID,
                        "oci_availability_domain": availabilityDomain,
                        "oci_subnet_ocid":         subnetID,
                        //"oci_pass_phrase":         passPhrase,
                },

                // Only build an OCI image
                Only: "oracle-oci",

                // Configure retries for intermittent errors
                // RetryableErrors:    DefaultRetryablePackerErrors,
                // TimeBetweenRetries: DefaultTimeBetweenPackerRetries,
                // MaxRetries:         DefaultMaxPackerRetries,
        }

        // Make sure the Packer build completes successfully
        ocid := packer.BuildArtifact(t, packerOptions)

        // Delete the OCI image after we're done
        defer oci.DeleteImage(t, ocid)
}
