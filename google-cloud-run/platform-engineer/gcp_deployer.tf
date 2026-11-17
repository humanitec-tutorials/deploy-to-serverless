# The identity the runner uses to deploy into GCP, depending on var.gcp_auth_mode
locals {
  gcp_use_service_account_key       = var.gcp_auth_mode == "service_account_key"
  gcp_deployer_uses_service_account = var.gcp_auth_mode != "workload_identity_principal"
  gke_project_id                    = coalesce(var.gke_project_id, var.gcp_project_id)

  # IAM member string for the deployer, used to grant it permissions on other resources
  gcp_deployer_iam_member = (
    local.gcp_deployer_uses_service_account
    ? "serviceAccount:${one(data.google_service_account.gcp_deployer[*].email)}"
    : format(
      "principal://iam.googleapis.com/projects/%s/locations/global/workloadIdentityPools/%s.svc.id.goog/subject/ns/%s/sa/%s",
      one(data.google_project.gke[*].number),
      local.gke_project_id,
      var.k8s_container_runner_namespace,
      var.k8s_container_runner_service_account,
    )
  )
}

# Reference the configured existing deployer Google service account
data "google_service_account" "gcp_deployer" {
  count      = local.gcp_deployer_uses_service_account ? 1 : 0
  account_id = var.gcp_deployer_service_account_name
  lifecycle {
    precondition {
      condition     = var.gcp_deployer_service_account_name != null
      error_message = "gcp_deployer_service_account_name must be set when gcp_auth_mode is \"${var.gcp_auth_mode}\"."
    }
  }
}

# The GKE project's number, which identifies its Workload Identity pool
data "google_project" "gke" {
  count      = local.gcp_deployer_uses_service_account ? 0 : 1
  project_id = local.gke_project_id
}
