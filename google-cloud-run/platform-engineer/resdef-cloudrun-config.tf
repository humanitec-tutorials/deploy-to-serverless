# This Resource Definition provides configuration values to other resources and to the workload
# Besides static values, it also reads a secret value from Google Secret Manager
resource "humanitec_resource_definition" "google_cloud_run_config" {
  driver_type = "humanitec/echo"
  id          = "${var.object_prefix}config"
  name        = "${var.object_prefix}config"
  type        = "config"
  driver_inputs = {
    values_string = jsonencode({
      # IAM member string of the deployer identity, e.g. "serviceAccount:..." or "principal://..."
      "gcp_deployer_iam_member" = local.gcp_deployer_iam_member
      "gcp_project_id"          = var.gcp_project_id
      "gcp_region"              = var.gcp_region
      "test_value"              = "THISISATESTVALUE"
    })
    secret_refs = jsonencode(merge(
      {
        "test_secret" = {
          "ref"   = google_secret_manager_secret.google_cloud_run_test.secret_id
          "store" = var.gsm_secret_store_name
        }
      },
      # Provide GCP deployer key only if configured
      local.gcp_use_service_account_key ? {
        "gcp_deployer_key" = {
          "ref"   = google_secret_manager_secret.gcp_deployer_key[0].secret_id
          "store" = var.gsm_secret_store_name
        }
      } : {}
    ))
  }
}

resource "humanitec_resource_definition_criteria" "google_cloud_run_config_criteria_0" {
  resource_definition_id = resource.humanitec_resource_definition.google_cloud_run_config.id
  app_id                 = humanitec_application.google_cloud_run.id
  env_id                 = humanitec_environment.google_cloud_run_development.id
  force_delete           = true
}
