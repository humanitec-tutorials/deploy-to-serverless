# This Resource Definition provisions a GCP service account to serve as
# the runtime service account for the Cloud Run execution
resource "humanitec_resource_definition" "cloudrun_runtime_service_account" {
  driver_type = "humanitec/opentofu-container-runner-builtin"
  id          = "${var.object_prefix}runtime-service-account"
  name        = "${var.object_prefix}runtime-service-account"
  type        = "gcp-service-account"
  driver_inputs = {
    values_string = jsonencode({
      "files" = {
        "main.tf" = <<-END_OF_TEXT
          terraform {
            required_providers {
              google = {
                source  = "hashicorp/google"
                version = ">= 6.0"
              }
              time = {
                source  = "hashicorp/time"
                version = ">= 0.12"
              }
            }
          }

          variable "project_id" {
            type        = string
            description = "GCP project that holds the service account."
          }
          variable "deployer_service_account_email" {
            type        = string
            description = "Account that deploys Cloud Run services and must act as this one."
          }
          variable "guresid" {
            type        = string
            description = "Globally unique Resource ID, which makes the account name unique."
          }
          provider "google" {
            project = var.project_id
          }
          locals {
            # account_id is capped at 30 chars by GCP. The GUResID is already a
            # lowercase hex string, so it only needs truncating.
            account_id = substr(join("-", ["cloudrun", var.guresid]), 0, 30)
          }

          resource "google_service_account" "runtime" {
            project      = var.project_id
            account_id   = local.account_id
            display_name = format("Cloud Run runtime for resource %s", var.guresid)
          }
          resource "google_service_account_iam_member" "deployer_acts_as_runtime" {
            service_account_id = google_service_account.runtime.name
            role               = "roles/iam.serviceAccountUser"
            member             = "serviceAccount:$\{var.deployer_service_account_email}"
          }
          resource "google_project_iam_member" "runtime_reads_secrets" {
            project = var.project_id
            role    = "roles/secretmanager.secretAccessor"
            member  = "serviceAccount:$\{google_service_account.runtime.email}"
          }
          # Wait to be sure that the IAM bindings are propagated, only on the first creation.
          resource "time_sleep" "iam_propagation" {
            create_duration = "60s"
            triggers = {
              service_account = google_service_account.runtime.unique_id
              act_as_binding  = google_service_account_iam_member.deployer_acts_as_runtime.id
              secret_binding  = google_project_iam_member.runtime_reads_secrets.id
            }
          }

          output "email" {
            value       = google_service_account.runtime.email
            description = "Email address identifying the provisioned service account"
          }
          output "console_url" {
            value       = format("https://console.cloud.google.com/iam-admin/serviceaccounts/details/%s?project=%s", google_service_account.runtime.unique_id, var.project_id)
            description = "URL to the Google Cloud console for easy access via the Orchestrator UI"
          }
          END_OF_TEXT
      }
      "runner" = {
        "namespace"       = var.k8s_container_runner_namespace
        "service_account" = var.k8s_container_runner_service_account
        "variables" = {
          "HOME" = "/home/my-user/workspace"
        }
      }
      "use_default_backend" = true
      "variables" = merge(
        {
          "deployer_service_account_email" = "$${resources[\"config.default#shared.env\"].outputs.gcp_deployer_service_account}"
          "guresid"                        = "$${context.res.guresid}"
          "project_id"                     = "$${resources[\"config.default#shared.env\"].outputs.gcp_project_id}"
        },
        # Provide GCP deployer key only if configured
        var.gcp_use_service_account_key ? {
          "GOOGLE_APPLICATION_CREDENTIALS" = "credentials.json"
        } : {}
      )
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

resource "humanitec_resource_definition_criteria" "cloudrun_runtime_service_account_criteria_0" {
  resource_definition_id = resource.humanitec_resource_definition.cloudrun_runtime_service_account.id
  app_id                 = humanitec_application.cloudrun.id
  env_id                 = humanitec_environment.cloudrun_development.id
  class                  = "cloudrun"
  force_delete           = true
}
