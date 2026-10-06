provider "humanitec" {
  org_id = var.humanitec_org_id
  # Authentication via CLI
}
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  # Authentication via CLI
}