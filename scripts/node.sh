echo "Running node.sh"

#######################################################
################# Turn Off the Firewall ###############
#######################################################
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################
################# Install Driverless AI ###############
#######################################################

cd /
curl -O https://s3.amazonaws.com/artifacts.h2o.ai/releases/ai/h2o/dai/rel-1.3.1-12/x86_64-centos7/dai-1.3.1-1.x86_64.rpm
rpm -i dai-1.3.1-1.x86_64.rpm
systemctl start dai
