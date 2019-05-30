#!/bin/bash

echo "Running node.sh"
#######################################################
################# Turn Off the Firewall ###############
#######################################################
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################
############### Install H2O Driverless AI #############
#######################################################
echo "Installing H2O Driverless AI..."
cd ~opc
curl -O https://s3.amazonaws.com/artifacts.h2o.ai/releases/ai/h2o/dai/rel-1.6.1-9/x86_64-centos7/dai-1.6.1-1.x86_64.rpm
rpm -i dai-1.6.1-1.x86_64.rpm

echo 0 > /proc/sys/vm/overcommit_memory
mkdir -p /opt/h2oai/dai/home/.driverlessai/
chown dai:dai /opt/h2oai/dai/home/.driverlessai
if [ -z "$KEY" ]
then
      echo "KEY is empty, not writing file"
else
      echo "Writing KEY to license.sig"
      echo $KEY > /opt/h2oai/dai/home/.driverlessai/license.sig
fi

#######################################################
################### Gather metadata ###################
#######################################################
json=$(curl -sSL http://169.254.169.254/opc/v1/instance/)
shape=$(echo $json | jq -r .shape)

#######################################################
################### GPU Configuration #################
#######################################################
if [[ $shape == *"GPU"* ]]; then
  echo "Running on GPU shape, calling nvidia setup..."
  nvidia-persistenced --user dai
  nvidia-smi -pm 1
else
  echo "Running on non-GPU shape, no nvidia gpu setup"
fi

#######################################################
############### Config H2O Driverless AI ##############
#######################################################
file="/etc/dai/config.toml"

echo "Setup htpasswd file"
yum install -y httpd-tools
htpasswd -bcB /etc/dai/htpasswd $DEFAULT_USER $DEFAULT_PW
chown dai:dai /etc/dai/htpasswd
chmod 600 /etc/dai/htpasswd

echo "Setup self signed cert"
openssl req -x509 -newkey rsa:4096 \
  -keyout /etc/dai/private_key.pem \
  -out /etc/dai/cert.pem -days 3650 \
  -nodes -subj "/O=Driverless AI"
chown dai:dai /etc/dai/{cert.pem,private_key.pem}
chmod 600 /etc/dai/{cert.pem,private_key.pem}

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
systemctl enable dai
systemctl start dai
