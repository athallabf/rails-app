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
  default     = 8080
}


variable "github_repo" {
  type        = string
  description = "The GitHub repository in 'owner/repo' format."
  default     = "athallabf/rails-app"
}