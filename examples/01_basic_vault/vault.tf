module "vault" {
  source = "../.."

  name             = "fk-basic-vault"
  compartment_ocid = var.compartment_ocid

  keys = {
    primary = {
      display_name = "fk-basic-vault-key"
      key_shape = {
        algorithm = "AES"
        length    = 32
      }
    }
  }

  freeform_tags = {
    project = "foggykitchen"
    example = "01_basic_vault"
  }
}
