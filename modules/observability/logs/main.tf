locals {
  prefix = "/${var.app}/${var.env}"
}

# 1) Log Groups por microservicio
resource "aws_cloudwatch_log_group" "svc" {
  for_each          = toset(var.microservices)
  name              = "${local.prefix}/${each.key}"
  retention_in_days = var.retention_in_days

  tags = {
    App       = var.app
    Env       = var.env
    Component = "logs"
    Managed   = "terraform"
    Service   = each.key
  }
}

# 2) Política IAM para que Fluent Bit publique en CloudWatch
data "aws_iam_policy_document" "fluentbit" {
  statement {
    sid     = "CreateDescribeGroups"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy",
      "logs:TagResource"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "StreamsAndEvents"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = [
      for lg in aws_cloudwatch_log_group.svc : "${lg.arn}:*"
    ]
  }
}

resource "aws_iam_policy" "fluentbit" {
  name   = "cwlogs-fluentbit-${var.app}-${var.env}"
  policy = data.aws_iam_policy_document.fluentbit.json
  tags = {
    App = var.app, Env = var.env, Managed = "terraform", Component = "logs"
  }
}

# 3) Rol IRSA para el ServiceAccount de Fluent Bit
data "aws_iam_policy_document" "irsa_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.fluentbit_namespace}:${var.fluentbit_sa_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "fluentbit" {
  name               = "irsa-fluentbit-${var.app}-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.irsa_trust.json

  tags = {
    App       = var.app
    Env       = var.env
    Managed   = "terraform"
    Component = "logs"
  }
}

resource "aws_iam_role_policy_attachment" "fluentbit" {
  role       = aws_iam_role.fluentbit.name
  policy_arn = aws_iam_policy.fluentbit.arn
}