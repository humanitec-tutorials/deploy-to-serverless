# Sample secret in Google Secret Manager
resource "google_secret_manager_secret" "google_cloud_run_test" {
  secret_id       = "${var.object_prefix}test-secret"
  deletion_policy = "DELETE"
  replication {
    auto {}
  }
}
resource "google_secret_manager_secret_version" "google_cloud_run_test" {
  secret      = google_secret_manager_secret.google_cloud_run_test.id
  secret_data = "${google_secret_manager_secret.google_cloud_run_test.secret_id}-value"
}

# Sample DB username secret in Google Secret Manager
resource "google_secret_manager_secret" "google_cloud_run_db_username" {
  secret_id       = "${var.object_prefix}db-username"
  deletion_policy = "DELETE"
  replication {
    auto {}
  }
}
resource "google_secret_manager_secret_version" "google_cloud_run_db_username" {
  secret      = google_secret_manager_secret.google_cloud_run_db_username.id
  secret_data = "example-db-username"
}

# Sample DB password secret in Google Secret Manager
resource "google_secret_manager_secret" "google_cloud_run_db_password" {
  secret_id       = "${var.object_prefix}db-password"
  deletion_policy = "DELETE"
  replication {
    auto {}
  }
}
resource "google_secret_manager_secret_version" "google_cloud_run_db_password" {
  secret      = google_secret_manager_secret.google_cloud_run_db_password.id
  secret_data = "example-db-password"
}

#####
# Deploy to GCP without using GKE Workload identity, i.e. other GKE or non-GKE
#####
resource "google_service_account_key" "gcp_deployer" {
  # Only create a key if requested
  count              = local.gcp_use_service_account_key ? 1 : 0
  service_account_id = data.google_service_account.gcp_deployer[0].name
}
resource "google_secret_manager_secret" "gcp_deployer_key" {
  count           = local.gcp_use_service_account_key ? 1 : 0
  secret_id       = "${var.object_prefix}gcp-deployer-key"
  deletion_policy = "DELETE"
  replication {
    auto {}
  }
}
resource "google_secret_manager_secret_version" "gcp_deployer_key" {
  count  = local.gcp_use_service_account_key ? 1 : 0
  secret = google_secret_manager_secret.gcp_deployer_key[0].id
  # private_key is the base64-encoded credentials.json file
  secret_data = base64decode(google_service_account_key.gcp_deployer[0].private_key)
}