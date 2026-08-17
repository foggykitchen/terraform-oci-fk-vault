module "workload_policy" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-policy.git"

  providers = {
    oci = oci.homeregion
  }

  tenancy_ocid = var.tenancy_ocid

  dynamic_group = {
    name          = "fk_vault_workload_dg"
    description   = "Dynamic group for the FoggyKitchen Vault workload example."
    matching_rule = "ALL {instance.id = '${module.compute.instance_id}'}"
  }

  policies = [
    {
      name        = "fk_vault_workload_secret_read_policy"
      description = "Allow the Vault workload example instance to read its Vault secret."
      statements = [
        "Allow dynamic-group fk_vault_workload_dg to read vaults in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_vault_workload_dg to read keys in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_vault_workload_dg to read secret-bundles in compartment id ${var.compartment_ocid}"
      ]
    }
  ]
}
