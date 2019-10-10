#!/bin/bash
sudo apt-get update
#sudo apt-get -y upgrade
sudo apt install -y build-essential unzip go-dep

#Installing go
wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz
sudo tar -xvf go1.13.1.linux-amd64.tar.gz
sudo mv go /usr/local

mkdir -p $HOME/go/src/terratest/test
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:/usr/bin:$PATH
cd $HOME/go/src/terratest/test
mv oci_test.go ./

cat  << EOF > Gopkg.toml
[[constraint]]
  name = "github.com/gruntwork-io/terratest"
  version = "0.19.1"
EOF

dep ensure

#Installing terraform
wget https://releases.hashicorp.com/terraform/0.12.10/terraform_0.12.10_linux_amd64.zip
unzip terraform_0.12.10_linux_amd64.zip
sudo mv terraform /usr/bin