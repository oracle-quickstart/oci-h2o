echo "Running node.sh"

#######################################################
################# Turn Off the Firewall ###############
#######################################################
echo "Adding port 12345 to firewall"
firewall-cmd --permanent --zone=public --add-port=12345/tcp
firewall-cmd --reload

#######################################################
############### Install H2O Driverless AI #############
#######################################################
echo "Installing H2O Driverless AI..."
cd /
curl -O https://s3.amazonaws.com/artifacts.h2o.ai/releases/ai/h2o/dai/rel-1.5.3-11/x86_64-centos7/dai-1.5.3-1.x86_64.rpm
rpm -i dai-1.5.3-1.x86_64.rpm

mkdir -p /opt/h2oai/dai/home/.driverlessai/
echo $key > /opt/h2oai/dai/home/.driverlessai/license.sig

#######################################################
################### GPU Configuration #################
#######################################################
nvidia-persistenced --user dai
nvidia-smi -pm 1

#######################################################
################ Start H2O Driverless AI ##############
#######################################################
sleep 1m
systemctl start dai