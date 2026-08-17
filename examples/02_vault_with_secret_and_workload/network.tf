module "vcn" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-vcn.git"

  compartment_ocid = var.compartment_ocid
  name             = "fk-vault-workload-vcn"
  vcn_cidr_blocks  = ["10.60.0.0/16"]

  create_service_gateway = true

  route_tables = {
    private = {
      route_rules = [
        {
          destination        = "all-services"
          destination_type   = "SERVICE_CIDR_BLOCK"
          network_entity_key = "service_gateway"
        }
      ]
    }
  }

  security_lists = {
    private = {
      egress_rules = [
        {
          protocol         = "all"
          destination      = module.vcn.oracle_services_network_cidr_block
          destination_type = "SERVICE_CIDR_BLOCK"
        }
      ]
    }
  }

  subnets = {
    private = {
      display_name               = "fk-vault-private-subnet"
      cidr_block                 = "10.60.10.0/24"
      route_table_key            = "private"
      security_list_keys         = ["private"]
      prohibit_internet_ingress  = true
      prohibit_public_ip_on_vnic = true
    }
  }
}
