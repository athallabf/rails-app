resource "google_cloud_run_v2_service_iam_member" "unauthenticated" {
  count = local.is_public ? 1 : 0

  name     = google_cloud_run_v2_service.main.name
  location = google_cloud_run_v2_service.main.location
  project  = google_cloud_run_v2_service.main.project
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_service_account_iam_member" "deployer_can_act_as_app_sa" {
  service_account_id = google_service_account.cloud_run_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:github-actions-deployer@${var.gcp_project_id}.iam.gserviceaccount.com"
}