variable "gcp_project_id" {
  type        = string
  description = "The GCP Project ID to deploy resources into."
}

variable "gcp_region" {
  type        = string
  description = "The GCP region for deployment."
  default     = "asia-southeast1"
}

variable "app_name" {
  type        = string
  description = "The name of the application."
  default     = "jarvis-demo"
}

variable "docker_image_url" {
  type        = string
  description = "The URL of the Docker image to deploy."
}

variable "container_port" {
  type        = number
  description = "The port the container listens on."
  default     = 80
}

variable "rails_master_key" {
  type        = string
  description = "The Rails master key for decrypting credentials."
  sensitive   = true
}

variable "environment_scaling_configs" {
  description = "A map of scaling configurations for each environment."
  type = map(object({
    min_instances = number
    max_instances = number
  }))
  default = {
    "staging"    = { min_instances = 0, max_instances = 1 },
    "production" = { min_instances = 1, max_instances = 2 }
  }
}

variable "allow_unauthenticated" {
  description = "A map to control public access for each environment."
  type        = map(bool)
  default = {
    "staging"    = true,
    "production" = true
  }
}