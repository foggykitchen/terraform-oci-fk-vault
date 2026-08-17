# terraform-oci-fk-vault

This repository contains a reusable Terraform / OpenTofu module and progressive examples for deploying Oracle Cloud Infrastructure (OCI) Vault, KMS keys, and optional Vault secrets in the FoggyKitchen catalog.

It is part of the [FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/) and is designed to compose cleanly with reusable OCI infrastructure modules such as `terraform-oci-fk-vcn`, `terraform-oci-fk-nsg`, and `terraform-oci-fk-compute`.

---

## Purpose

The goal of this module is to provide a clean, composable, and educational reference implementation for OCI Vault:

- Focused on Vault, KMS key, and secret lifecycle
- Suitable for baseline Vault deployments and workload-integrated secret storage
- Keeps networking, compute, IAM policies, and workload access outside the module boundary

This module intentionally stays focused on the OCI Vault service itself. VCNs, NSGs, compute instances, dynamic groups, IAM policies, and application-level secret retrieval should be composed through dedicated modules or workflow layers.

---

## What the module does

The module creates:

- One OCI Vault
- One or more OCI KMS keys, software-protected by default for cost-conscious labs
- Optional OCI Vault secrets
- Optional key auto-rotation settings
- Optional secret rotation, generation, and rule blocks

The module intentionally does not create:

- VCNs, subnets, NSGs, gateways, or private DNS
- Compute instances or application runtimes
- IAM policies or dynamic groups
- Secret consumers
- Terraform state backends

Each of those concerns belongs in its own dedicated module or workflow layer.

---

## Repository Structure

```bash
terraform-oci-fk-vault/
├── examples/
│   ├── 01_basic_vault/
│   ├── 02_vault_with_secret_and_workload/
│   └── README.md
├── main.tf
├── inputs.tf
├── outputs.tf
├── versions.tf
├── LICENSE
└── README.md
```

All examples demonstrate incremental OCI Vault patterns, starting from a basic Vault and progressing to workload composition.

---

## Example Usage

### Basic Vault and KMS key

```hcl
module "vault" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-vault.git?ref=main"

  name             = "fk-basic-vault"
  compartment_ocid = var.compartment_ocid

  keys = {
    primary = {
      display_name = "fk-basic-key"
      key_shape = {
        algorithm = "AES"
        length    = 32
      }
    }
  }
}
```

### Vault secret with source-controlled placeholder content

```hcl
module "vault" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-vault.git?ref=main"

  name             = "fk-app-vault"
  compartment_ocid = var.compartment_ocid

  secrets = {
    app_config = {
      secret_name = "app-config"
      description = "Demo application configuration."
      metadata = {
        app = "demo"
      }
    }
  }

  secret_contents = {
    app_config = jsonencode({ username = "demo", endpoint = "https://example.invalid" })
  }
}
```

For real credentials, pass `secrets` through a sensitive variable source and keep state storage protected.

The examples keep the Vault type at the module default, `DEFAULT`, so labs do not create costly OCI Virtual Private Vaults.
The examples also keep KMS keys at the module default, `SOFTWARE`, rather than HSM-backed keys.

---

## Module Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `name` | `string` | yes | OCI Vault display name |
| `compartment_ocid` | `string` | yes | Compartment OCID |
| `vault_type` | `string` | no | `DEFAULT` or `VIRTUAL_PRIVATE` |
| `vault_time_of_deletion` | `string` | no | Optional RFC3339 Vault deletion timestamp |
| `keys` | `map(object)` | no | KMS keys to create in the Vault |
| `external_key_ids` | `map(string)` | no | Existing key OCIDs addressable by secret `key_name` |
| `secrets` | `map(object)` | no | Vault secrets to create |
| `secret_contents` | `map(string)` | no | Sensitive secret content keyed by matching `secrets` keys |
| `defined_tags` | `map(string)` | no | Defined tags applied to module resources |
| `freeform_tags` | `map(string)` | no | Freeform tags applied to module resources |

### `keys` object schema

```hcl
keys = map(object({
  display_name = string
  key_shape = object({
    algorithm = optional(string, "AES")
    length    = optional(number, 32)
    curve_id  = optional(string)
  })
  protection_mode          = optional(string, "SOFTWARE")
  is_auto_rotation_enabled = optional(bool, false)
  auto_key_rotation_details = optional(object({
    rotation_interval_in_days = optional(number)
    time_of_schedule_start    = optional(string)
  }))
  time_of_deletion = optional(string)
  defined_tags     = optional(map(string), {})
  freeform_tags    = optional(map(string), {})
}))
```

### `secrets` object schema

```hcl
secrets = map(object({
  secret_name              = string
  description              = optional(string)
  key_name                 = optional(string, "primary")
  key_id                   = optional(string)
  content                  = optional(string)
  content_is_base64        = optional(bool, false)
  content_type             = optional(string, "BASE64")
  content_name             = optional(string)
  stage                    = optional(string, "CURRENT")
  enable_auto_generation   = optional(bool, false)
  metadata                 = optional(map(string), {})
  rotation_config            = optional(object({ ... }))
  secret_generation_context  = optional(object({ ... }))
  secret_rules               = optional(list(object({ ... })), [])
  defined_tags               = optional(map(string), {})
  freeform_tags              = optional(map(string), {})
}))
```

Prefer `secret_contents` for real values:

```hcl
secrets = {
  app_config = {
    secret_name = "app-config"
  }
}

secret_contents = {
  app_config = var.app_config_value
}
```

---

## Module Outputs

| Name | Description |
|------|-------------|
| `vault_id` | OCI Vault OCID |
| `vault_name` | OCI Vault display name |
| `vault_type` | OCI Vault type |
| `management_endpoint` | OCI Vault management endpoint |
| `crypto_endpoint` | OCI Vault crypto endpoint |
| `key_ids` | Map of created KMS key names to OCIDs |
| `keys` | Selected KMS key attributes |
| `secret_ids` | Map of created secret names to OCIDs |
| `secrets` | Selected secret attributes without content |

---

## Examples

See [examples/README.md](examples/README.md) for the progressive lab sequence.

---

## License

Licensed under the Universal Permissive License (UPL), Version 1.0.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
