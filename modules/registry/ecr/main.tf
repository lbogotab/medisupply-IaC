locals {
  repo_names = {
    for r in var.repos : r => "ecr-${r}-medisupply-${var.env}"
  }

  lifecycle_policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Mantener últimas ${var.lifecycle_keep} imágenes (por tagStatus:any)"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = var.lifecycle_keep
      }
      action = { type = "expire" }
    }]
  })
}

resource "aws_ecr_repository" "this" {
  for_each = local.repo_names
  name     = each.value

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  force_delete = true

  tags = {
    App       = var.app
    Env       = var.env
    Component = "ecr"
    managed   = "terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = aws_ecr_repository.this
  repository = each.value.name
  policy     = local.lifecycle_policy
}