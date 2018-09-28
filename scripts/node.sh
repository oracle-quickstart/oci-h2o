echo "Running node.sh"

#######################################################
################# Turn Off the Firewall ###############
#######################################################
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################
################### GPU Configuration #################
#######################################################
nvidia-smi -pm 1

#######################################################
################# Install Driverless AI ###############
#######################################################
cd /
curl -O https://s3.amazonaws.com/artifacts.h2o.ai/releases/ai/h2o/dai/rel-1.3.1-12/x86_64-centos7/dai-1.3.1-1.x86_64.rpm
rpm -i dai-1.3.1-1.x86_64.rpm

mkdir -p /opt/h2oai/dai/home/.driverlessai/
key="przchWviWuDZjJrLAXkq-V4jGq7qLu-MLTZtXWFDt8iWomD-VdIpi_tRzrto5erNOEoOgrqhYEp1GKrXdm7yIE73K-ntw2xg2U_WcJZyM_bekzMVxkM8mGAVjFlJq0s2jScSYRgllf5rZxzUFi-9s0-zpBvuusyJEMhOSCgV5E5Ytiwlnq4WScFChDIzdHW9-l2VOAzQmowipfVasZT32JnD1yN8uJ-I7u08T2A4STh7ZkFCIBFsdXmZPKCxc3huaqPB_fNFutWomXAfz2StjhAVvr6ptZTsJfXdbK1ry93X9UnLvdMVRt0E8hAYTiioj48DN3MiYe40NqgkHBtRFWxpY2Vuc2VfdmVyc2lvbjoxCnNlcmlhbF9udW1iZXI6MjY5NDMKbGljZW5zZWVfb3JnYW5pemF0aW9uOk9yYWNsZQpsaWNlbnNlZV9lbWFpbDpiZW4ubGFja2V5QG9yYWNsZS5jb20KbGljZW5zZWVfdXNlcl9pZDoyNjk0Mwppc19oMm9faW50ZXJuYWxfdXNlOmZhbHNlCmNyZWF0ZWRfYnlfZW1haWw6a2F5QGgyby5haQpjcmVhdGlvbl9kYXRlOjIwMTgvMDkvMjgKcHJvZHVjdDpEcml2ZXJsZXNzQUkKbGljZW5zZV90eXBlOnRyaWFsCmV4cGlyYXRpb25fZGF0ZToyMDE4LzEwLzE5Cg=="
echo $key > /opt/h2oai/dai/home/.driverlessai/license.sig
