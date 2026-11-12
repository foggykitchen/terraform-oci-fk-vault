# Synthetic fixtures only. Every run is plan-only; no tenancy credentials are used.
mock_provider "oci" {
  mock_resource "oci_kms_key" {
    defaults = { "current_key_version" = "mock-value", "external_key_reference_details" = [{ "external_key_id" = "MOCK_OCID_MOCK", "external_key_version_id" = "MOCK_OCID_MOCK" }], "id" = "MOCK_OCID_KEY", "is_primary" = false, "replica_details" = [{ "replication_id" = "MOCK_OCID_MOCK" }], "restored_from_key_id" = "MOCK_OCID_MOCK", "state" = "AVAILABLE", "time_created" = "mock-value", "vault_id" = "MOCK_OCID_MOCK" }
  }
  mock_resource "oci_kms_vault" {
    defaults = { "crypto_endpoint" = "mock-value", "external_key_manager_metadata_summary" = [{ "external_vault_endpoint_url" = "mock-value", "oauth_metadata_summary" = [{ "client_app_id" = "MOCK_OCID_MOCK", "idcs_account_name_url" = "mock-value" }], "private_endpoint_id" = "MOCK_OCID_MOCK", "vendor" = "mock-value" }], "id" = "MOCK_OCID_VAULT", "is_primary" = false, "is_vault_replicable" = false, "management_endpoint" = "mock-value", "replica_details" = [{ "replication_id" = "MOCK_OCID_MOCK" }], "restored_from_vault_id" = "MOCK_OCID_MOCK", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_vault_secret" {
    defaults = { "current_version_number" = "mock-value", "id" = "MOCK_OCID_SECRET", "is_auto_generation_enabled" = false, "is_replica" = false, "last_rotation_time" = "mock-value", "lifecycle_details" = "mock-value", "next_rotation_time" = "mock-value", "rotation_status" = "mock-value", "source_region_information" = [{ "source_key_id" = "MOCK_OCID_MOCK", "source_region" = "mock-value", "source_vault_id" = "MOCK_OCID_MOCK" }], "state" = "AVAILABLE", "time_created" = "mock-value", "time_of_current_version_expiry" = "mock-value", "time_of_deletion" = "mock-value" }
  }
}
variables {
  name             = "compatibility"
  compartment_ocid = "MOCK_OCID_COMPARTMENT"
}

run "oci9_plan" {
  command = plan
}
