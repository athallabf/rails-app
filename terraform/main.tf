provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}



# non-privileged service account for the Cloud Run service itself
resource "google_service_account" "cloud_run_sa" {
  account_id   = "${var.app_name}-cloud-run-sa"
  display_name = "Service Account for ${var.app_name} Cloud Run service"
}


resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
  ])

  service                   = each.key
  disable_dependent_services = false
}

resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.gcp_region
  repository_id = "${var.app_name}-repo"
  description   = "Docker repository for ${var.app_name}"
  format        = "DOCKER"
  depends_on    = [google_project_service.apis]
}


resource "google_cloud_run_v2_service" "main" {
  name     = var.app_name
  location = var.gcp_region


  template {

    scaling {
      min_instance_count = 1
      max_instance_count = 2
    }

    containers {
      image = var.docker_image_url != "" ? var.docker_image_url : "gcr.io/cloudrun/hello"
      ports {
        container_port = var.container_port
      }
      resources {
        limits = {
          memory = "512Mi"
          cpu    = "1"
        }
      }
    }
    service_account = google_service_account.cloud_run_sa.email

  }

  depends_on = [google_project_service.apis]
}

