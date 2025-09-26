provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

resource "google_storage_bucket" "tfstate" {
  project       = var.gcp_project_id
  name          = "devops-469009-asia-southeast1-tfstate"
  location      = var.gcp_region
  storage_class = "STANDARD"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }
}

resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
  ])

  service                    = each.key
  disable_dependent_services = false
}

resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.gcp_region
  repository_id = "${var.app_name}-repo"
  description   = "Docker repository for ${var.app_name}"
  format        = "DOCKER"
  depends_on    = [google_project_service.apis]
}


// Dari iam.tf (Workload Identity Federation & Deployer SA)
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "${var.app_name}-pool"
  display_name              = "Identity Pool for ${var.app_name}"
  description               = "Manages identities for the GitHub Actions pipeline"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions Provider"
  description                        = "OIDC provider for main and staging branches"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"             = "assertion.sub",
    "attribute.actor"            = "assertion.actor",
    "attribute.repository"       = "assertion.repository",
    "attribute.repository_owner" = "assertion.repository_owner",
    "attribute.ref"              = "assertion.ref",
  }

  attribute_condition = "attribute.repository == '${var.github_repo}' && (attribute.ref == 'refs/heads/main' || attribute.ref == 'refs/heads/staging')"
}

resource "google_service_account" "github_actions_sa" {
  account_id   = "github-actions-deployer"
  display_name = "Service Account for GitHub Actions CI/CD WIF"
  description  = "Used by GitHub Actions to deploy the application via Terraform."
}

resource "google_project_iam_member" "github_actions_roles" {
  for_each = toset([
    "roles/run.admin",
    "roles/viewer",
    "roles/artifactregistry.writer",
    "roles/iam.serviceAccountUser",
    "roles/storage.admin",
  ])

  project = var.gcp_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

resource "google_service_account_iam_member" "github_actions_wif_user" {
  service_account_id = google_service_account.github_actions_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_repo}"
}