# This Resource Definition emulates a Postgres database by providing all required outputs
# but not actually provisioning anything.
# It does read credentials from a Google Secret Manager though
resource "humanitec_resource_definition" "cloudrun_postgres" {
  driver_type = "humanitec/echo"
  id          = "${var.object_prefix}postgres"
  name        = "${var.object_prefix}postgres"
  type        = "postgres"
  driver_inputs = {
    values_string = jsonencode({
      "host" = "${var.object_prefix}db.example.com"
      "name" = "${var.object_prefix}db"
      "port" = 5432
    })
    secret_refs = jsonencode({
      "username" = {
        "ref"   = google_secret_manager_secret.cloudrun_db_username.secret_id
        "store" = var.gsm_secret_store_name
      }
      "password" = {
        "ref"   = google_secret_manager_secret.cloudrun_db_password.secret_id
        "store" = var.gsm_secret_store_name
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "cloudrun_postgres_criteria_0" {
  resource_definition_id = resource.humanitec_resource_definition.cloudrun_postgres.id
  app_id                 = humanitec_application.cloudrun.id
  env_id                 = humanitec_environment.cloudrun_development.id
  force_delete           = true
}
