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

echo 0 > /proc/sys/vm/overcommit_memory

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

  # Starting NVIDIA Persistence Mode
  nvidia-persistenced --persistence-mode

  ### need to do more of this...
  # http://docs.h2o.ai/driverless-ai/latest-stable/docs/userguide/install/linux-rpm.html

  # Installing OpenCL
  ### to do
  #sudo yum -y clean all
  #sudo yum -y makecache
  #sudo yum -y update
  #wget http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/c/clinfo-2.1.17.02.09-1.el7.x86_64.rpm
  #wget http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/o/ocl-icd-2.2.12-1.el7.x86_64.rpm
  #sudo rpm -if ocl-icd-2.2.12-1.el7.x86_64.rpm
  #sudo rpm -if clinfo-2.1.17.02.09-1.el7.x86_64.rpm
  #clinfo
  #mkdir -p /etc/OpenCL/vendors && \
  #    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

  # Installing cuDNN
  #sudo yum install libcudnn7-devel

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

dataDir="/data"
mkdir -p $dataDir/dai
chown dai:dai $dataDir/dai

file="/etc/dai/config.toml"
echo "Change $file"
cp $file $file.bak
sed -i -e "s/#authentication_method = \"unvalidated\"/authentication_method = \"local\"/g" $file
sed -i -e "s/#local_htpasswd_file = \"\"/local_htpasswd_file = \"\/etc\/dai\/htpasswd\"/g" $file
sed -i -e "s/#enable_https = false/enable_https = true/g" $file
sed -i -e "s/#ssl_key_file = \"\/etc\/dai\/private_key.pem\"/ssl_key_file = \"\/etc\/dai\/private_key.pem\"/g" $file
sed -i -e "s/#ssl_crt_file = \"\/etc\/dai\/cert.pem\"/ssl_crt_file = \"\/etc\/dai\/cert.pem\"/g" $file
# use ~ as regex delimiter to avoid escaping / in $dataDir
sed -i -e "s~#data_directory = \"./tmp\"~data_directory = \"$dataDir/dai\"~g" $file

#######################################################
################ Start H2O Driverless AI ##############
#######################################################
echo "Sleeping 1m before starting dai service"
sleep 1m
systemctl start dai
