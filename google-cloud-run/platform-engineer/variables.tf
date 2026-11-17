variable "humanitec_org_id" {
  description = "Humanitec Organization ID"
  type        = string
}
variable "object_prefix" {
  description = "Universal prefix for all objects to create"
  type        = string
  default     = "google-cloud-run-guide-"
}
variable "gcp_project_id" {
  description = "Your Google Cloud project ID"
  type        = string
}
variable "gcp_region" {
  description = "Google Cloud region to use for resources, e.g. 'europe-west3'"
  type        = string
}
variable "gsm_secret_store_name" {
  description = "Name of the Orchestrator secret store registration for Google Secret Manager"
  type        = string
}
variable "gcp_auth_mode" {
  description = <<-EOT
    How the runner authenticates against Google Cloud. One of:
    - "workload_identity_principal": GKE Workload Identity Federation, with IAM roles granted directly to the principal of the runner's Kubernetes service account. No Google service account is involved.
    - "workload_identity_service_account": GKE Workload Identity, with the runner's Kubernetes service account impersonating the Google service account set in `gcp_deployer_service_account_name`.
    - "service_account_key": a key is created for the Google service account set in `gcp_deployer_service_account_name` and handed to the runner. Use this for non-GKE clusters or GKE without Workload Identity. The key is stored in the local state, so protect the state file and destroy the setup when done.
  EOT
  type        = string
  validation {
    condition     = contains(["workload_identity_principal", "workload_identity_service_account", "service_account_key"], var.gcp_auth_mode)
    error_message = "gcp_auth_mode must be one of \"workload_identity_principal\", \"workload_identity_service_account\", \"service_account_key\"."
  }
}
variable "gcp_deployer_service_account_name" {
  description = "Name of the existing Google service account that deploys into GCP, e.g. 'my-account'. Required unless gcp_auth_mode is \"workload_identity_principal\""
  type        = string
  default     = null
  nullable    = true
}
variable "gke_project_id" {
  description = "Project ID of the GKE cluster running the Container Runner, which owns the Workload Identity pool. Only used with gcp_auth_mode \"workload_identity_principal\". Defaults to gcp_project_id"
  type        = string
  default     = null
  nullable    = true
}
variable "k8s_container_runner_namespace" {
  description = "Kubernetes namespace of the container runner"
  type        = string
  default     = "humanitec-runner"
}
variable "k8s_container_runner_service_account" {
  description = "Kubernetes service account for the container runner Jobs"
  type        = string
  default     = "humanitec-runner"
}
variable "k8s-runner-cluster-resource-definition-id" {
  description = "ID of the Resource Definition of type `k8s-cluster` that defines the runner cluster to use"
  type        = string
}
variable "agent-resource-definition-id" {
  description = "ID of the Resource Definition of type `agent` that defines the Humanitec Agent to use. Leave empty if not using an Agent"
  type        = string
  nullable    = true
}
