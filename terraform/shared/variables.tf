variable "gcp_project_id" {
  type        = string
  description = "The GCP Project ID."
}

variable "gcp_region" {
  type        = string
  description = "The GCP region for shared resources."
  default     = "asia-southeast1"
}

variable "app_name" {
  type        = string
  description = "The base name of the application."
  default     = "jarvis-demo"
}

variable "github_repo" {
  type        = string
  description = "The GitHub repository in 'owner/repo' format."
}