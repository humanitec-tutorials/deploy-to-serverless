# Sample secret in Google Secret Manager
resource "google_secret_manager_secret" "cloudrun_test" {
  secret_id       = "${var.object_prefix}test-secret"
  deletion_policy = "DELETE"
  replication {
    auto {}
  }
}
resource "google_secret_manager_secret_version" "cloudrun_test" {
  secret      = google_secret_manager_secret.cloudrun_test.id
  secret_data = "${google_secret_manager_secret.cloudrun_test.secret_id}-value"
}

# Sample DB username secret in Google Secret Manager
resource "google_secret_manager_secret" "cloudrun_db_username" {
  secret_id       = "${var.object_prefix}db-username"
  deletion_policy = "DELETE"
  replication {
    auto {}
  }
}
resource "google_secret_manager_secret_version" "cloudrun_db_username" {
  secret      = google_secret_manager_secret.cloudrun_db_username.id
  secret_data = "example-db-username"
}

# Sample DB password secret in Google Secret Manager
resource "google_secret_manager_secret" "cloudrun_db_password" {
  secret_id       = "${var.object_prefix}db-password"
  deletion_policy = "DELETE"
  replication {
    auto {}
  }
}
resource "google_secret_manager_secret_version" "cloudrun_db_password" {
  secret      = google_secret_manager_secret.cloudrun_db_password.id
  secret_data = "example-db-password"
}
