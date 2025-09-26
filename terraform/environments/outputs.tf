output "cloud_run_url" {
  description = "value of the Cloud Run service URL"
  value       = google_cloud_run_v2_service.main.uri
}