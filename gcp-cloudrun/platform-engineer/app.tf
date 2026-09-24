resource "humanitec_application" "cloudrun" {
  id   = "${var.object_prefix}app"
  name = "${var.object_prefix}app"
}

resource "humanitec_environment" "cloudrun_development" {
  app_id = humanitec_application.cloudrun.id
  id     = "development"
  name   = "Development"
  type   = "development"
}
