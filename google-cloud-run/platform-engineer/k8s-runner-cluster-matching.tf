# These matching criteria make the GKE cluster you specified the runner cluster
# for the deployment execution

# Match the existing `k8s-cluster` Resource Definition
resource "humanitec_resource_definition_criteria" "google_cloud_run_runner_cluster_criteria_0" {
  resource_definition_id = var.k8s-runner-cluster-resource-definition-id
  app_id                 = humanitec_application.google_cloud_run.id
}

# Match the existing `agent` Resource Definition, if any
resource "humanitec_resource_definition_criteria" "google_cloud_run_agent_criteria_0" {
  count                  = var.agent-resource-definition-id != "" && var.agent-resource-definition-id != null ? 1 : 0
  resource_definition_id = var.agent-resource-definition-id
  app_id                 = humanitec_application.google_cloud_run.id
}