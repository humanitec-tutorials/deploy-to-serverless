resource "humanitec_application" "google_cloud_run" {
  id   = "${var.object_prefix}app"
  name = "${var.object_prefix}app"
}

resource "humanitec_environment" "google_cloud_run_development" {
  app_id = humanitec_application.google_cloud_run.id
  id     = "development"
  name   = "Development"
  type   = "development"
}
