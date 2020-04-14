#!/usr/bin/env bash

# Builds a marketplace.zip for ORM.  This uses a local copy of existing TF.

out_file="marketplace.zip"

echo "Cleaning up...."
rm -rf ./tmp_package
rm ${out_file}

echo "Creating tmp dir...."
mkdir ./tmp_package

echo "Copying .tf files to tmp dir...."
cp -v ../*.tf ./tmp_package
echo "Copying schema.yaml to tmp dir...."
cp -v ./schema.yaml ./tmp_package
echo "Copying script directory to tmp dir...."
cp -rv ../scripts ./tmp_package

echo "Removing provider.tf...."
rm ./tmp_package/provider.tf

# Add latest git log entry
git log -n 1 > tmp_package/git.log

echo "Creating $out_file ...."
cd tmp_package
zip -r ${out_file} *
cd ..
mv tmp_package/${out_file} ./

echo "Deleting tmp dir...."
rm -rf ./tmp_package
