variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "region" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "ssh_authorized_keys" {
  type        = list(string)
  description = "SSH public keys injected into the demo compute instance."
  default     = []
}

variable "demo_secret_value" {
  type        = string
  description = "Demo secret value. Use only placeholder or lab data unless state storage is secured."
  sensitive   = true
  default     = "change-me-lab-value"
}
