
resource "aws_ecr_repository" "app" {
  name = "${var.project_name}-ecr-repository"

  image_tag_mutability = "IMMUTABLE"
}