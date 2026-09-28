# This Resource Definition provisions a simple emptyDir volume
resource "humanitec_resource_definition" "cloudrun_volume_emptydir" {
  driver_type = "humanitec/template"
  id          = "${var.object_prefix}volume-emptydir"
  name        = "${var.object_prefix}volume-emptydir"
  type        = "volume"
  driver_inputs = {
    values_string = jsonencode({
      "templates" = {
        "outputs" = <<-END_OF_TEXT
          google-cloud-run:
            emptyDir:
              medium: Memory
        END_OF_TEXT       
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "cloudrun_volume_emptydir_criteria_0" {
  resource_definition_id = resource.humanitec_resource_definition.cloudrun_volume_emptydir.id
  app_id                 = humanitec_application.cloudrun.id
  env_id                 = humanitec_environment.cloudrun_development.id
  force_delete           = true
}
