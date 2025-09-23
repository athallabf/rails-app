resource "google_storage_bucket" "tfstate" {
  project      = var.gcp_project_id
  name         = "devops-469009-asia-southeast1-tfstate" # <-- Use the same unique name
  location     = var.gcp_region
  storage_class = "STANDARD"

  # Best practice: Prevent accidental deletion of the state bucket
  lifecycle {
    prevent_destroy = true
  }

  # Best practice: Keep a history of state files
  versioning {
    enabled = true
  }
}