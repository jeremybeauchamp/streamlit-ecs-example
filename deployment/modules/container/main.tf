resource "aws_ecr_repository" "main" {
  name         = var.name
  force_delete = true

  tags = {
    Project = var.project
  }
}

resource "null_resource" "push_image" {
  depends_on = [aws_ecr_repository.main]

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/push_image.sh ${var.local_image} ${split("/", aws_ecr_repository.main.repository_url)[0]} ${aws_ecr_repository.main.name}"
  }
  triggers = {
    always = timestamp()
  }
}