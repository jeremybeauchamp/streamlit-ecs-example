output "repo_arn" {
  value = aws_ecr_repository.main.arn
}

output "repo_url" {
  value = aws_ecr_repository.main.repository_url
}