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
cd /
curl -O https://s3.amazonaws.com/artifacts.h2o.ai/releases/ai/h2o/dai/rel-1.3.1-12/x86_64-centos7/dai-1.3.1-1.x86_64.rpm
rpm -i dai-1.3.1-1.x86_64.rpm

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
systemctl start dai

#http://h2o-release.s3.amazonaws.com/h2o/rel-lambert/5/docs-website/deployment/multinode.html
