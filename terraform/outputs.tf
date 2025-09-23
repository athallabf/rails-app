output "cloud_run_url" {
  description = "value of the Cloud Run service URL"
  value       = google_cloud_run_v2_service.main.uri
}

output "github_actions_sa_email" {
  description = "The email of the Service Account for GitHub Actions."
  value       = google_service_account.github_actions_sa.email
}