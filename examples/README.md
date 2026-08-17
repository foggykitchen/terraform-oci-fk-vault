# OCI Vault with Terraform/OpenTofu - Training Examples

This directory contains runnable examples for the **terraform-oci-fk-vault** module.
The examples focus on practical OCI Vault deployment patterns, from a basic Vault and KMS key to workload-oriented secrets.

These examples are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and are used across OCI and multicloud courses covering security foundations, key management, secrets management, and workload integration.

---

## Published Examples

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| 01 | **Basic Vault** | OCI Vault, AES KMS key, baseline key management |
| 02 | **Private Vault Access with Secret and Workload** | Vault secret, private workload subnet, Service Gateway path to OCI services, instance-principal IAM with `terraform-oci-fk-policy`, `terraform-oci-fk-vcn`, `terraform-oci-fk-nsg`, `terraform-oci-fk-compute` integration |

---

## How to Use

The example directory contains:
- Terraform/OpenTofu configuration (`.tf`)
- A focused `README.md` explaining the goal of the example
- A minimal, runnable architecture

To run the basic Vault example:

```bash
cd examples/01_basic_vault
tofu init
tofu plan
tofu apply
```

To run the private Vault access with secret and workload example:

```bash
cd examples/02_vault_with_secret_and_workload
tofu init
tofu plan
tofu apply
```

## Design Principles

- One example = one architectural goal
- No unused or placeholder infrastructure resources
- Clear separation of concerns between Vault, KMS keys, secrets, networking, and workloads
- Examples designed to integrate with other FoggyKitchen modules such as VCN, NSG, and Compute
- Secret values are lab placeholders unless OpenTofu state is stored in a protected backend

---

## Related Resources

- [FoggyKitchen OCI Vault Module (terraform-oci-fk-vault)](../)
- [FoggyKitchen OCI VCN Module (terraform-oci-fk-vcn)](https://github.com/foggykitchen/terraform-oci-fk-vcn)
- [FoggyKitchen OCI NSG Module (terraform-oci-fk-nsg)](https://github.com/foggykitchen/terraform-oci-fk-nsg)
- [FoggyKitchen OCI Compute Module (terraform-oci-fk-compute)](https://github.com/foggykitchen/terraform-oci-fk-compute)
- [FoggyKitchen Azure Key Vault Module (terraform-az-fk-key-vault)](https://github.com/foggykitchen/terraform-az-fk-key-vault)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
