# This workload Resource Definition defines a Generic Workload
# It provisions a containerized workload as a Google Cloud Run service
# It uses the Container Driver and a Driver image provided specifically for this purpose
resource "humanitec_resource_definition" "google_cloud_run_workload" {
  driver_type = "humanitec/container-builtin"
  id          = "${var.object_prefix}workload"
  name        = "${var.object_prefix}workload"
  type        = "workload"
  driver_inputs = {
    values_string = jsonencode({
      "job" = {
        "image"            = "ghcr.io/humanitec/cloudrun-container-runner:latest"
        "namespace"        = var.k8s_container_runner_namespace
        "service_account"  = var.k8s_container_runner_service_account
        "shared_directory" = "/home/my-user/workspace"
        "variables" = merge(
          {
            # Reference and thus create a GCP service account resource for the Cloud Run runtime
            "CLOUDRUN_RUNTIME_SERVICE_ACCOUNT" = "$${resources.gcp-service-account.outputs.email}"
            "CLOUDSDK_CORE_PROJECT"            = "$${resources[\"config.default#shared.env\"].outputs.gcp_project_id}"
            "CLOUDSDK_RUN_REGION"              = "$${resources[\"config.default#shared.env\"].outputs.gcp_region}"
            "CLOUDRUN_SERVICE_NAME_PREFIX"     = "${var.object_prefix}$${context.app.id}-$${context.env.id}"
          },
          # Provide GCP deployer key only if configured
          var.gcp_use_service_account_key ? {
            "GOOGLE_APPLICATION_CREDENTIALS" = "credentials.json"
          } : {}
        )
      }
    })
    secrets_string = jsonencode(merge(
      # Provide GCP deployer key only if configured
      var.gcp_use_service_account_key ? {
        "files" = {
          "credentials.json" = "$${resources[\"config.default#shared.env\"].outputs.gcp_deployer_key}"
        }
      } : {}
      )
    )
  }
}

# The workload Resource Defition must match the class being used in the deployment commands
resource "humanitec_resource_definition_criteria" "google_cloud_run_workload_criteria_0" {
  resource_definition_id = resource.humanitec_resource_definition.google_cloud_run_workload.id
  app_id                 = humanitec_application.google_cloud_run.id
  env_id                 = humanitec_environment.google_cloud_run_development.id
  class                  = "google-cloud-run"
  force_delete           = true
}
