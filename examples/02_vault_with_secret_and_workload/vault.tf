module "vault" {
  source = "../.."

  name             = "fk-workload-vault"
  compartment_ocid = var.compartment_ocid

  secrets = {
    app_config = {
      secret_name = "fk-demo-app-config"
      description = "Demo application configuration secret."
      metadata = {
        application = "fk-demo"
        environment = "lab"
      }
    }
  }

  secret_contents = {
    app_config = var.demo_secret_value
  }

  freeform_tags = {
    project = "foggykitchen"
    example = "02_vault_with_secret_and_workload"
  }
}
