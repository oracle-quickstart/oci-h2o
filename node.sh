#!/bin/bash

echo "Running node.sh..."

#######################################################
################## Size up Boot Volume ################
#######################################################
echo "Sizing up the boot volume..."
/usr/libexec/oci-growfs -y

#######################################################
################# Turn off the Firewall ###############
#######################################################
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################
############### Install H2O Driverless AI #############
#######################################################
echo "Installing H2O Driverless AI..."
cd ~opc
curl -O https://s3.amazonaws.com/artifacts.h2o.ai/releases/ai/h2o/dai/rel-1.9.1-53/x86_64-centos7/dai-1.9.1-1.x86_64.rpm
rpm -i dai*.rpm

# WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
echo 1 > /proc/sys/vm/overcommit_memory

# WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
echo never > /sys/kernel/mm/transparent_hugepage/enabled

#######################################################
################### Gather metadata ###################
#######################################################
json=$(curl -sSL http://169.254.169.254/opc/v1/instance/)
shape=$(echo $json | jq -r .shape)
echo "I'm running on a $shape."

#######################################################
################### GPU Configuration #################
#######################################################

if [[ $shape == *"GPU"* ]]; then
  echo "Running on a GPU shape, doing NVIDIA setup..."

  ### The doc is here...
  # http://docs.h2o.ai/driverless-ai/latest-stable/docs/userguide/install/linux-rpm.html

  nvidia-persistenced --persistence-mode

  # Install OpenCL
  #wget http://developer.download.nvidia.com/compute/DevZone/OpenCL/Projects/oclMultiThreads.tar.gz
  #tar -xvf oclMultiThreads.tar.gz
  #cd "NVIDIA GPU Computing SDK/OpenCL"
  #### The make file doesn't seem to have the right targets.  This is weird...
  #make
  #make install

else
  echo "Running on a non-GPU shape, no NVIDIA GPU setup needed."
fi

#######################################################
############### Config H2O Driverless AI ##############
#######################################################

echo "Setup htpasswd file"
yum install -y httpd-tools
htpasswd -bcB /etc/dai/htpasswd $USER $PASSWORD
chown dai:dai /etc/dai/htpasswd
chmod 600 /etc/dai/htpasswd

echo "Setup self signed cert"
openssl req -x509 -newkey rsa:4096 \
  -keyout /etc/dai/private_key.pem \
  -out /etc/dai/cert.pem -days 3650 \
  -nodes -subj "/O=Driverless AI"
chown dai:dai /etc/dai/{cert.pem,private_key.pem}
chmod 600 /etc/dai/{cert.pem,private_key.pem}

file="/etc/dai/config.toml"
echo "Change $file"
cp $file $file.bak
sed -i -e "s/#authentication_method = \"unvalidated\"/authentication_method = \"local\"/g" $file
sed -i -e "s/#local_htpasswd_file = \"\"/local_htpasswd_file = \"\/etc\/dai\/htpasswd\"/g" $file
sed -i -e "s/#enable_https = false/enable_https = true/g" $file
sed -i -e "s/#ssl_key_file = \"\/etc\/dai\/private_key.pem\"/ssl_key_file = \"\/etc\/dai\/private_key.pem\"/g" $file
sed -i -e "s/#ssl_crt_file = \"\/etc\/dai\/cert.pem\"/ssl_crt_file = \"\/etc\/dai\/cert.pem\"/g" $file

#######################################################
################ Start H2O Driverless AI ##############
#######################################################
echo "Sleeping 1m before starting dai service"
sleep 1m
systemctl start dai
