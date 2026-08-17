output "vault_id" {
  description = "OCI Vault OCID."
  value       = oci_kms_vault.this.id
}

output "vault_name" {
  description = "OCI Vault display name."
  value       = oci_kms_vault.this.display_name
}

output "vault_type" {
  description = "OCI Vault type."
  value       = oci_kms_vault.this.vault_type
}

output "management_endpoint" {
  description = "OCI Vault management endpoint."
  value       = oci_kms_vault.this.management_endpoint
}

output "crypto_endpoint" {
  description = "OCI Vault crypto endpoint."
  value       = oci_kms_vault.this.crypto_endpoint
}

output "key_ids" {
  description = "Map of created KMS key names to OCIDs."
  value       = { for name, key in oci_kms_key.this : name => key.id }
}

output "keys" {
  description = "Selected KMS key attributes."
  value = {
    for name, key in oci_kms_key.this : name => {
      id              = key.id
      display_name    = key.display_name
      protection_mode = key.protection_mode
      state           = key.state
    }
  }
}

output "secret_ids" {
  description = "Map of created secret names to OCIDs."
  value       = { for name, secret in oci_vault_secret.this : name => secret.id }
}

output "secrets" {
  description = "Selected secret attributes without secret content."
  value = {
    for name, secret in oci_vault_secret.this : name => {
      id                     = secret.id
      secret_name            = secret.secret_name
      current_version_number = secret.current_version_number
      state                  = secret.state
    }
  }
}
