# This workload Resource Definition provisions a containerized workload as a Google Cloud Run service
# It uses the Container Driver and a Driver image provided specifically for this purpose
resource "humanitec_resource_definition" "cloudrun_workload" {
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
        "variables" = {
          # Reference and thus create a GCP service account resource for the Cloud Run runtime
          "CLOUDRUN_RUNTIME_SERVICE_ACCOUNT" = "$${resources.gcp-service-account.outputs.email}"
          "CLOUDSDK_CORE_PROJECT"            = "$${resources[\"config.default#shared.env\"].outputs.gcp_project_id}"
          "CLOUDSDK_RUN_REGION"              = "$${resources[\"config.default#shared.env\"].outputs.gcp_region}"
          "CLOUDRUN_SERVICE_NAME_PREFIX"     = "${var.object_prefix}$${context.app.id}-$${context.env.id}"
        }
      }
    })
  }
}

# The workload Resource Defition must match the class being used in the deployment commands
resource "humanitec_resource_definition_criteria" "cloudrun_workload_criteria_0" {
  resource_definition_id = resource.humanitec_resource_definition.cloudrun_workload.id
  app_id                 = humanitec_application.cloudrun.id
  env_id                 = humanitec_environment.cloudrun_development.id
  class                  = "cloudrun"
  force_delete           = true
}
