variable "name" {
  type        = string
  description = "Display name used for the OCI Vault."

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must not be empty."
  }
}

variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID where the Vault, KMS keys, and secrets will be created."
}

variable "vault_type" {
  type        = string
  description = "OCI Vault type. DEFAULT is cost-friendly; VIRTUAL_PRIVATE provides dedicated isolation."
  default     = "DEFAULT"

  validation {
    condition     = contains(["DEFAULT", "VIRTUAL_PRIVATE"], var.vault_type)
    error_message = "vault_type must be DEFAULT or VIRTUAL_PRIVATE."
  }
}

variable "vault_time_of_deletion" {
  type        = string
  description = "Optional RFC3339 timestamp for scheduled Vault deletion."
  default     = null
}

variable "keys" {
  type = map(object({
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
  description = "Map of OCI KMS keys to create in the Vault."
  default = {
    primary = {
      display_name = "fk-vault-primary-key"
      key_shape = {
        algorithm = "AES"
        length    = 32
      }
    }
  }

  validation {
    condition = alltrue([
      for key in values(var.keys) : contains(["AES", "RSA", "ECDSA"], key.key_shape.algorithm)
    ])
    error_message = "Each key_shape.algorithm must be AES, RSA, or ECDSA."
  }

  validation {
    condition = alltrue([
      for key in values(var.keys) : contains(["HSM", "SOFTWARE", "EXTERNAL"], key.protection_mode)
    ])
    error_message = "Each protection_mode must be HSM, SOFTWARE, or EXTERNAL."
  }
}

variable "external_key_ids" {
  type        = map(string)
  description = "Existing KMS key OCIDs that secrets may reference by key_name."
  default     = {}
}

variable "secrets" {
  type = map(object({
    secret_name            = string
    description            = optional(string)
    key_name               = optional(string, "primary")
    key_id                 = optional(string)
    content                = optional(string)
    content_is_base64      = optional(bool, false)
    content_type           = optional(string, "BASE64")
    content_name           = optional(string)
    stage                  = optional(string, "CURRENT")
    enable_auto_generation = optional(bool, false)
    metadata               = optional(map(string), {})
    rotation_config = optional(object({
      is_scheduled_rotation_enabled = optional(bool)
      rotation_interval             = optional(string)
      target_system_details = object({
        target_system_type = string
        adb_id             = optional(string)
        function_id        = optional(string)
      })
    }))
    secret_generation_context = optional(object({
      generation_template = string
      generation_type     = string
      passphrase_length   = optional(number)
      secret_template     = optional(string)
    }))
    secret_rules = optional(list(object({
      rule_type                                     = string
      is_enforced_on_deleted_secret_versions        = optional(bool)
      is_secret_content_retrieval_blocked_on_expiry = optional(bool)
      secret_version_expiry_interval                = optional(string)
      time_of_absolute_expiry                       = optional(string)
    })), [])
    defined_tags  = optional(map(string), {})
    freeform_tags = optional(map(string), {})
  }))
  description = "Map of OCI Vault secrets to create. Prefer secret_contents for real content so secret metadata remains usable with for_each."
  default     = {}

  validation {
    condition = alltrue([
      for secret in values(var.secrets) : can(regex("^[A-Za-z0-9._-]+$", secret.secret_name))
    ])
    error_message = "Secret names may contain only letters, numbers, hyphens, underscores, and periods."
  }

  validation {
    condition = alltrue([
      for secret in values(var.secrets) : contains(["BASE64"], secret.content_type)
    ])
    error_message = "Only BASE64 secret content is currently supported by OCI Vault."
  }
}

variable "secret_contents" {
  type        = map(string)
  description = "Sensitive map of secret content keyed by the matching secrets map key. Values are base64-encoded unless the matching secret sets content_is_base64 to true."
  default     = {}
  sensitive   = true
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags applied to all resources created by the module."
  default     = {}
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags applied to all resources created by the module."
  default     = {}
}
