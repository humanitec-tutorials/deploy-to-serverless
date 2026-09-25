# This Resource Definition provides configuration values to other resources and to the workload
# Besides static values, it also reads a secret value from Google Secret Manager
resource "humanitec_resource_definition" "cloudrun_config" {
  driver_type = "humanitec/echo"
  id          = "${var.object_prefix}config"
  name        = "${var.object_prefix}config"
  type        = "config"
  driver_inputs = {
    values_string = jsonencode({
      "gcp_deployer_service_account" = "${var.gcp_container_runner_service_account_name}@${var.gcp_project_id}.iam.gserviceaccount.com"
      "gcp_project_id"               = var.gcp_project_id
      "gcp_region"                   = var.gcp_region
      "test_value"                   = "THISISATESTVALUE"
    })
    secret_refs = jsonencode({
      "test_secret" = {
        "ref"   = google_secret_manager_secret.cloudrun_test.secret_id
        "store" = var.gsm_secret_store_name
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "cloudrun_config_criteria_0" {
  resource_definition_id = resource.humanitec_resource_definition.cloudrun_config.id
  app_id                 = humanitec_application.cloudrun.id
  env_id                 = humanitec_environment.cloudrun_development.id
  force_delete           = true
}
