# Info

The files in this directory are unused by normal terraform deployments. They are
to support Oracle Resource Manager (ORM) and Marketplace deployments

# Files
- `build_mkpl.sh`, packages TF/scripts with mkpl specific files. Output: `mkpl.zip`
- `build_zip.sh`, packages TF/scripts for ORM *TESTING*. Output: `package.zip`
- `image_subscription.tf`, added to `mkpl.zip`
- `mkpl-schema.yaml`, added to `mkpl.zip`
- `mkpl-variables.tf` added to `mkpl.zip`
- `schema.yaml` added to `package.zip`
