module "compute_nsg" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-nsg.git"

  name             = "fk-vault-workload-nsg"
  compartment_ocid = var.compartment_ocid
  vcn_id           = module.vcn.vcn_id

  security_rules = [
    {
      name             = "egress-to-oci-services"
      direction        = "EGRESS"
      protocol         = "all"
      destination      = module.vcn.oracle_services_network_cidr_block
      destination_type = "SERVICE_CIDR_BLOCK"
    }
  ]
}
