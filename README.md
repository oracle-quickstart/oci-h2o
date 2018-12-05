# oci-h2o
[simple](simple) is a Terraform module that will deploy H2O Driverless AI on OCI. Instructions on how to use it are below.  In addition, here's a video walkthrough:

<p align="center">
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/wFhR3gip4ko/0.jpg)](https://www.youtube.com/watch?v=wFhR3gip4ko)
</p>

## Prerequisites
First off you'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

## Clone the Module
Now, you'll want a local copy of this repo.  You can make that with the commands:

    git clone https://github.com/cloud-partners/oci-h2o.git
    cd oci-h2o/gpu
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

If that's good, we can go ahead and apply the deploy:

    terraform apply

You'll need to enter `yes` when prompted.  The apply should take about seven minutes to run.  Once complete, you'll see something like this:

![](./images/04%20-%20terraform%20apply.png)

When the apply is complete, the infrastructure will be deployed, but cloud-init scripts will still be running.  Those will wrap up asynchronously.  So, it'll be a few more minutes before your cluster is accessible.  Now is a good time to get a coffee.

## Connect to the Cluster

The apply prints the URL of H2O Driverless AI when it completes.  Logging into that we see:

![](./images/05%20-%20agreement.png)

After accepting the agreement, we can see the login screen:

![](./images/06%20-%20login.png)

The documentation [here](http://docs.h2o.ai/driverless-ai/latest-stable/docs/userguide/launching.html) provides a walkthrough and some good next steps.  There are a bunch of public data sets to get you started.  Here's an example of an experiment I set up on one using that walkthrough.

![](./images/07%20-%20experiment.png)

## SSH to a Node
These machines are using Oracle Enterprise Linux (OEL).  The default login is opc.  You can SSH into the machine with a command like this:

    ssh -i ~/.ssh/oci opc@<Public IP Address>

![](./images/08%20-%20ssh.png)

H2O is installed under `/opt/h2o`.  Logs from the install are under `/var/log/messages` and viewable with root privileges.

## View the Cluster in the Console
You can also login to the web console [here](https://console.us-phoenix-1.oraclecloud.com/a/compute/instances) to view the IaaS that is running the cluster.

![](./images/09%20-%20console.png)

## Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy it:

    terraform destroy

You'll need to enter `yes` when prompted.  Once complete, you'll see something like this:

![](./images/10%20-%20terraform%20destroy.png)
