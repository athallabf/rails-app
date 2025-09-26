provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

locals {
  environment       = terraform.workspace == "default" ? "production" : terraform.workspace
  scaling_config    = var.environment_scaling_configs[local.environment]
  is_public         = var.allow_unauthenticated[local.environment]
  suffixed_app_name = "${var.app_name}-${local.environment}"
}

# non-privileged service account for the Cloud Run service itself
resource "google_service_account" "cloud_run_sa" {
  account_id   = "${local.suffixed_app_name}-sa"
  display_name = "Service Account for ${local.suffixed_app_name} Cloud Run service"
}

resource "google_cloud_run_v2_service" "main" {
  name     = local.suffixed_app_name
  location = var.gcp_region

  template {
    scaling {
      min_instance_count = local.scaling_config.min_instances
      max_instance_count = local.scaling_config.max_instances
    }

    containers {
      image = var.docker_image_url
      ports {
        container_port = var.container_port
      }
      resources {
        limits = {
          memory = "512Mi"
          cpu    = "1"
        }
      }
      env {
        name  = "RAILS_MASTER_KEY"
        value = var.rails_master_key
      }
    }
    service_account = google_service_account.cloud_run_sa.email
  }
}