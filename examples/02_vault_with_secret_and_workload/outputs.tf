output "vault_id" {
  value = module.vault.vault_id
}

output "secret_ids" {
  value = module.vault.secret_ids
}

output "instance_id" {
  value = module.compute.instance_id
}

output "instance_private_ip" {
  value = module.compute.instance_private_ip
}

output "vcn_id" {
  value = module.vcn.vcn_id
}

output "workload_dynamic_group_id" {
  value = module.workload_policy.dynamic_group_id
}

output "workload_policy_ids" {
  value = module.workload_policy.policy_ids
}
