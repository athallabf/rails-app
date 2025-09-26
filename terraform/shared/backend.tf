terraform {
  backend "gcs" {
    bucket = "devops-469009-asia-southeast1-tfstate"
    prefix = "terraform/state/shared" # <-- Prefix khusus untuk shared infra
  }
}