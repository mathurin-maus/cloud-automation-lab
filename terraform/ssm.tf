
resource "aws_ssm_parameter" "desired_image_tag" {
  name  = "/${var.project_name}/image-tag"
  type  = "String"
  value = "initial"

  lifecycle {
    ignore_changes = [value]
  }
}