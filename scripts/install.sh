#!/bin/bash

echo "Running install.sh..."

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

#######################################################
################### GPU Configuration #################
#######################################################
if [[ $shape == *"GPU"* ]]; then
  echo "Running on GPU shape, calling nvidia setup..."
  nvidia-persistenced --user dai
  nvidia-smi -pm 1

  echo "Creating nvidia-persistenced-dai.service in /usr/lib/systemd/system"
  cat << EOF > /usr/lib/systemd/system/nvidia-persistenced-dai.service
[Unit]
Description=NVIDIA Persistence Daemon as user dai
Wants=syslog.target

[Service]
Type=forking
PIDFile=/var/run/nvidia-persistenced/nvidia-persistenced-dai.pid
Restart=always
ExecStart=/usr/bin/nvidia-persistenced --verbose --user dai
ExecStopPost=/bin/rm -rf /var/run/nvidia-persistenced

[Install]
WantedBy=multi-user.target
EOF
  echo "Enabling nvidia-persistenced-dai.service"
  systemctl enable nvidia-persistenced-dai.service
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

mkdir -p $dataDir/dai
chown dai:dai $dataDir/dai

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
