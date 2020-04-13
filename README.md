[![Actions Status](https://github.com/oci-quickstart/oci-h2o/workflows/OCI-Marketplace/badge.svg)](https://github.com/oci-quickstart/oci-h2o/actions)

# oci-quickstart-h2o

This is a Terraform module that deploys [H2O.ai Driverless AI](https://www.h2o.ai/products/) on [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure).  It is developed jointly by Oracle and H2O.ai.

Instructions on how to use it are below.  In addition, here's a video walkthrough:

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/wFhR3gip4ko/0.jpg)](https://www.youtube.com/watch?v=wFhR3gip4ko)

## Prerequisites
First off you'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/oracle/oci-quickstart-prerequisites).

DAI requires a license key. If you don't already have a key, you can get a [trial key](https://www.h2o.ai/try-driverless-ai/). You can deploy these templates before you get a key, but you'll be prompted for a key at first login.

## Clone the Module
Now, you'll want a local copy of this repo. You can make that with the commands:

    git clone https://github.com/oracle-quickstart/oci-h2o.git
    cd oci-h2o
    ls

That should give you this:

![](./images/01%20-%20git%20clone.png)

We now need to initialize the directory with the module in it.  This makes the module aware of the OCI provider.  You can do this by running:

    terraform init

This gives the following output:

![](./images/02%20-%20terraform%20init.png)

## Deploy
Now for the main attraction.  Let's make sure the plan looks good:

    terraform plan

That gives:

![](./images/03%20-%20terraform%20plan.png)

The next command will deploy H2O DAI using the values in the `variables.tf` file:
- `key`: Set to the value of your key. If empty, you will be prompted to enter your key at first login.
- `shape`: Default `BM.GPU2.2`, these templates support both CPU and GPU (higher performance) shapes.
- `ad_number`: Default `0`, choose a value where you have *quota* for the desired shape.
- `disk_size_gb`: Default `0`, size of block volume in GB for data, min 50. If set to 0 volume will not be created/mounted
- `user`: Default `admin`, these templates set up local authentication using file `/etc/dai/htpasswd`
- `password`: Default `admin`

If that's good, we can go ahead and apply the deploy:

    terraform apply

You'll need to enter `yes` when prompted.  The apply should take about seven minutes to run.  Once complete, you'll see something like this:

![](./images/04%20-%20terraform%20apply.png)

When the `apply` is complete, the infrastructure will be deployed, but the cloud-init scripts will still be running.  Those will wrap up asynchronously.  So, it'll be a few more minutes before your DAI instance is accessible.  Now is a good time to get a coffee.

## Connect to DAI

The `apply` prints the URL of H2O Driverless AI when it completes.  The deployment creates a self-signed certificate, so you'll need to confirm the exception.

Logging into that we see:

![](./images/05%20-%20agreement.png)

After accepting the agreement, we can see the login screen. Use the login defined in the `variables.tf` file:

![](./images/06%20-%20login.png)

The documentation [here](http://docs.h2o.ai/driverless-ai/latest-stable/docs/userguide/launching.html) provides a walkthrough and some good next steps.  There are a bunch of public data sets to get you started.  Here's an example of an experiment I set up on one using that walkthrough.

![](./images/07%20-%20experiment.png)

## SSH to the Instance
This machine is using Oracle Linux (OL).  The default login is opc.  You can SSH into the machine with a command like this:

    ssh -i ~/.ssh/oci opc@<Public IP Address>

![](./images/08%20-%20ssh.png)

H2O is installed under `/opt/h2o`.  Logs from the install are under `/var/log/messages` and viewable with root privileges.

## View DAI in the Console
You can also login to the web console [here](https://console.us-ashburn-1.oraclecloud.com/a/compute/instances) to view the IaaS that is running DAI.

![](./images/09%20-%20console.png)

## Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy it:

    terraform destroy

You'll need to enter `yes` when prompted.  Once complete, you'll see something like this:

![](./images/10%20-%20terraform%20destroy.png)
