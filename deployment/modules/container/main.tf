resource "aws_ecr_repository" "main" {
  name         = var.name
  force_delete = true

  tags = {
    Project = var.project
  }
}