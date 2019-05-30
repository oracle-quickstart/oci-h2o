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
############### Disk setup ############################
#######################################################

# Currently always 0 or 1
diskCount=$DISK_COUNT

# iscsiadm discovery/login
# loop over various ip's but needs to only attempt disks that actually
# do/will exist.
if [ $diskCount -gt 0 ] ;
then
  echo "Number of disks diskCount: $diskCount"
  for n in `seq 2 $((diskCount+1))`; do
    echo "Disk $((n-2)), attempting iscsi discovery/login of 169.254.2.$n ..."
    success=1
    while [[ $success -eq 1 ]]; do
      iqn=$(iscsiadm -m discovery -t sendtargets -p 169.254.2.$n:3260 | awk '{print $2}')
      if  [[ $iqn != iqn.* ]] ;
      then
        echo "Error: unexpected iqn value: $iqn"
        sleep 10s
        continue
      else
        echo "Success for iqn: $iqn"
        success=0
      fi
    done
    iscsiadm -m node -o update -T $iqn -n node.startup -v automatic
    iscsiadm -m node -T $iqn -p 169.254.2.$n:3260 -l
  done
else
  echo "Zero block volumes, not calling iscsiadm, diskCount: $diskCount"
fi

# not matter what we're mounting, we're placing data at the same path
dataDir="/data"
mkdir -p $dataDir

# choose between sdb or md0, $device unused if 0 disks
if [ $diskCount -gt 1 ] ;
then
  echo "More than 1 volume, RAIDing..."
  device="/dev/md0"
  # use **all** iscsi disks to build raid, there's a short race between
  # iscsiadm retuning and the disk symlinks being created, also mdadm
  # doesn't care about consistent device names
  sleep 4s
  disks=$(ls /dev/disk/by-path/ip-169.254*)
  echo "Block disks found: $disks"
  mdadm --create --verbose --force --run $device --level=0 \
    --raid-devices=$diskCount \
    $disks
else
  device="/dev/sdb"
fi

if [ $diskCount -gt 0 ] ;
then
  echo "Creating filesystem and mounting on /data..."
  mke2fs -F -t ext4 -b 4096 -E lazy_itable_init=1 -O sparse_super,dir_index,extent,has_journal,uninit_bg -m1 $device
  mount -t ext4 -o noatime $device $dataDir
  UUID=$(lsblk -no UUID $device)
  echo "UUID=$UUID   $dataDir    ext4   defaults,noatime,_netdev,nofail,discard,barrier=0 0 1" | sudo tee -a /etc/fstab
else
  echo "No filesystem to create, skipping"
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
