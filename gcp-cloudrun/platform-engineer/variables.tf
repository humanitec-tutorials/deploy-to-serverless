variable "humanitec_org_id" {
  description = "Humanitec Organization ID"
  type        = string
}
variable "object_prefix" {
  description = "Universal prefix for all objects to create"
  type        = string
  default     = "cloudrun-guide-"
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
variable "gcp_container_runner_service_account_name" {
  description = "Name of the GCP service account associated with the Container Runner, e.g. 'my-account'"
  type        = string
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
