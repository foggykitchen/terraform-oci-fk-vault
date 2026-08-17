locals {
  key_ids = merge(
    var.external_key_ids,
    { for key_name, key in oci_kms_key.this : key_name => key.id }
  )
  secret_content_keys = nonsensitive(toset(keys(var.secret_contents)))
}

resource "oci_kms_vault" "this" {
  compartment_id = var.compartment_ocid
  display_name   = var.name
  vault_type     = var.vault_type

  defined_tags     = var.defined_tags
  freeform_tags    = var.freeform_tags
  time_of_deletion = var.vault_time_of_deletion
}

resource "oci_kms_key" "this" {
  for_each = var.keys

  compartment_id      = var.compartment_ocid
  display_name        = each.value.display_name
  management_endpoint = oci_kms_vault.this.management_endpoint
  protection_mode     = each.value.protection_mode

  defined_tags  = merge(var.defined_tags, each.value.defined_tags)
  freeform_tags = merge(var.freeform_tags, each.value.freeform_tags)

  is_auto_rotation_enabled = each.value.is_auto_rotation_enabled
  time_of_deletion         = each.value.time_of_deletion

  key_shape {
    algorithm = each.value.key_shape.algorithm
    length    = each.value.key_shape.length
    curve_id  = each.value.key_shape.curve_id
  }

  dynamic "auto_key_rotation_details" {
    for_each = each.value.auto_key_rotation_details == null ? [] : [each.value.auto_key_rotation_details]

    content {
      rotation_interval_in_days = auto_key_rotation_details.value.rotation_interval_in_days
      time_of_schedule_start    = auto_key_rotation_details.value.time_of_schedule_start
    }
  }
}

resource "oci_vault_secret" "this" {
  for_each = var.secrets

  compartment_id         = var.compartment_ocid
  vault_id               = oci_kms_vault.this.id
  key_id                 = coalesce(each.value.key_id, local.key_ids[each.value.key_name])
  secret_name            = each.value.secret_name
  description            = each.value.description
  enable_auto_generation = each.value.enable_auto_generation
  metadata               = each.value.metadata

  defined_tags  = merge(var.defined_tags, each.value.defined_tags)
  freeform_tags = merge(var.freeform_tags, each.value.freeform_tags)

  dynamic "secret_content" {
    for_each = each.value.content == null && !contains(local.secret_content_keys, each.key) ? [] : [each.value]

    content {
      content_type = secret_content.value.content_type
      content      = secret_content.value.content_is_base64 ? coalesce(secret_content.value.content, try(var.secret_contents[each.key], null)) : base64encode(coalesce(secret_content.value.content, try(var.secret_contents[each.key], null)))
      name         = secret_content.value.content_name
      stage        = secret_content.value.stage
    }
  }

  dynamic "secret_generation_context" {
    for_each = each.value.secret_generation_context == null ? [] : [each.value.secret_generation_context]

    content {
      generation_template = secret_generation_context.value.generation_template
      generation_type     = secret_generation_context.value.generation_type
      passphrase_length   = secret_generation_context.value.passphrase_length
      secret_template     = secret_generation_context.value.secret_template
    }
  }

  dynamic "rotation_config" {
    for_each = each.value.rotation_config == null ? [] : [each.value.rotation_config]

    content {
      is_scheduled_rotation_enabled = rotation_config.value.is_scheduled_rotation_enabled
      rotation_interval             = rotation_config.value.rotation_interval

      target_system_details {
        target_system_type = rotation_config.value.target_system_details.target_system_type
        adb_id             = rotation_config.value.target_system_details.adb_id
        function_id        = rotation_config.value.target_system_details.function_id
      }
    }
  }

  dynamic "secret_rules" {
    for_each = each.value.secret_rules

    content {
      rule_type                                     = secret_rules.value.rule_type
      is_enforced_on_deleted_secret_versions        = secret_rules.value.is_enforced_on_deleted_secret_versions
      is_secret_content_retrieval_blocked_on_expiry = secret_rules.value.is_secret_content_retrieval_blocked_on_expiry
      secret_version_expiry_interval                = secret_rules.value.secret_version_expiry_interval
      time_of_absolute_expiry                       = secret_rules.value.time_of_absolute_expiry
    }
  }

  lifecycle {
    precondition {
      condition     = each.value.key_id != null || contains(keys(local.key_ids), each.value.key_name)
      error_message = "Each secret must either provide key_id or reference a key_name from keys or external_key_ids."
    }

    precondition {
      condition     = each.value.content != null || contains(local.secret_content_keys, each.key) || each.value.enable_auto_generation || each.value.secret_generation_context != null
      error_message = "Each secret must provide content, a matching secret_contents entry, enable_auto_generation, or secret_generation_context."
    }

  }
}
