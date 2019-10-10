workflow "Terraform" {
  resolves = "terraform-plan"
  on = "push"
}

action "filter-to-pr-open-synced" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "terraform-fmt" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.4.2"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform"
  }
}

action "terraform-init" {
  uses = "hashicorp/terraform-github-actions/init@v0.4.2"
  needs = "terraform-fmt"
  secrets = ["TF_VAR_compartment_ocid", "TF_VAR_fingerprint", "TF_VAR_private_key", "TF_VAR_tenancy_ocid", "TF_VAR_user_ocid"]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform"
  }
}

action "terraform-validate" {
  uses = "hashicorp/terraform-github-actions/validate@v0.4.2"
  needs = "terraform-init"
  secrets = ["TF_VAR_compartment_ocid", "TF_VAR_fingerprint", "TF_VAR_private_key", "TF_VAR_tenancy_ocid", "TF_VAR_user_ocid"]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform"
  }
}

action "terraform-plan" {
  uses = "hashicorp/terraform-github-actions/plan@v0.4.2"
  needs = "terraform-validate"
  secrets = ["TF_VAR_compartment_ocid", "TF_VAR_fingerprint", "TF_VAR_private_key", "TF_VAR_tenancy_ocid", "TF_VAR_user_ocid"]
  env = {
    TF_ACTION_WORKING_DIR = "."
    # If you're using Terraform workspaces, set this to the workspace name.
    TF_ACTION_WORKSPACE = "default"
  }
}

