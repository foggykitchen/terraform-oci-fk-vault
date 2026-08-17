module "compute" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-compute.git"

  name             = "fk-vault-workload"
  tenancy_ocid     = var.tenancy_ocid
  compartment_ocid = var.compartment_ocid
  subnet_id        = module.vcn.subnet_ids["private"]

  deployment_mode          = "instance"
  shape                    = "VM.Standard.E4.Flex"
  operating_system_version = "9"
  shape_config = {
    ocpus         = 1
    memory_in_gbs = 8
  }

  assign_public_ip    = false
  nsg_ids             = module.compute_nsg.nsg_ids
  ssh_authorized_keys = var.ssh_authorized_keys

  user_data = base64encode(<<-EOF
    #cloud-config
    write_files:
      - path: /etc/foggykitchen-vault-demo.env
        owner: root:root
        permissions: "0640"
        content: |
          OCI_VAULT_ID=${module.vault.vault_id}
          OCI_SECRET_ID=${module.vault.secret_ids["app_config"]}
    runcmd:
      - [ bash, -lc, "echo FoggyKitchen Vault workload placeholder > /etc/motd" ]
  EOF
  )
}
