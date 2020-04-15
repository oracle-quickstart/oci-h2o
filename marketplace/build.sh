#!/usr/bin/env bash

# Builds mkpl .zip for ORM. Uses local copy of existing TF.
# Output: $out_file

out_file="mkpl.zip"

echo "TEST cleanup"
rm -rf ./tmp_package
rm $out_file

# set after cleanup, since failure of that rm is ok
set -euo

echo "Creating tmp dir...."
mkdir ./tmp_package

echo "Copying .tf files to tmp dir...."
cp -v ../terraform/*.tf ./tmp_package
echo "Copying schema.yaml to tmp dir...."
cp -v ../terraform/schema.yaml ./tmp_package
echo "Copying script directory to tmp dir...."
cp -rv ./scripts ./tmp_package


echo "Removing provider.tf...."
rm ./tmp_package/provider.tf

# Add latest git log entry
git log -n 1 > tmp_package/git.log

echo "Creating $out_file ...."
cd tmp_package
zip -r $out_file *
cd ..
mv tmp_package/$out_file ./

echo "Deleting tmp dir...."
rm -rf ./tmp_package
