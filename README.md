[![Actions Status](https://github.com/oci-quickstart/oci-h2o/workflows/OCI-Marketplace/badge.svg)](https://github.com/oci-quickstart/oci-h2o/actions)

# oci-h2o

This is a Terraform module that deploys [H2O.ai Driverless AI](https://www.h2o.ai/products/) on [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure).  It is developed jointly by Oracle and H2O.ai.

## Ways to Deploy
* Marketplace - There's a listing [here](https://cloudmarketplace.oracle.com/marketplace/en_US/listing/59502906) that deploys the same code that is in this Quick Start.  It's kept in sync using our [CI/CD](https://blogs.oracle.com/cloud-infrastructure/better-marketplace-listings-with-cicd).
* Resource Manager - [OCI Resource Manager (ORM)](https://docs.cloud.oracle.com/iaas/Content/ResourceManager/Concepts/resourcemanager.htm) is Oracle's Terraform as a service.  Instructions on deploying with it follow.

## Prerequisites
First off you'll need an OCI tenancy.  If you don't have one, you can sign up [here](https://www.oracle.com/cloud/free/).

DAI requires a license key. If you don't already have a key, you can get a [trial key](https://www.h2o.ai/try-driverless-ai/). You can deploy these templates before you get a key, but you'll be prompted for a key at first login.

## Deploy
To deploy, simply click the magic button!

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://console.us-ashburn-1.oraclecloud.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-quickstart/oci-h2o/archive/master.zip)

That will direct you over to ORM.  Once there, walk through the wizard.  When that's complete, run an apply.

## Connect to DAI

The apply prints the URL of H2O Driverless AI when it completes.  The deployment creates a self-signed certificate, so you'll need to confirm the exception.

Logging into that we see:

![](./images/01%20-%20agreement.png)

After accepting the agreement, we can see the login screen. Use the login defined in the `variables.tf` file:

![](./images/02%20-%20login.png)

The documentation [here](http://docs.h2o.ai/driverless-ai/latest-stable/docs/userguide/launching.html) provides a walkthrough and some good next steps.  There are a bunch of public data sets to get you started.  Here's an example of an experiment I set up on one using that walkthrough.

![](./images/03%20-%20experiment.png)

## SSH to the Instance
This machine is using Oracle Linux (OL).  The default login is opc.  You can SSH into the machine with a command like this:

    ssh -i ~/.ssh/oci opc@<Public IP Address>

![](./images/04%20-%20ssh.png)

H2O is installed under `/opt/h2o`.  Logs from the install are under `/var/log/messages` and viewable with root privileges.

## View DAI in the Console
You can also login to the web console [here](https://console.us-ashburn-1.oraclecloud.com/a/compute/instances) to view the IaaS that is running DAI.

![](./images/05%20-%20console.png)

## Destroy the Deployment
When you no longer need the deployment, you can login to ORM and destroy the deployment.  When that's complete, you can destroy the stack.
