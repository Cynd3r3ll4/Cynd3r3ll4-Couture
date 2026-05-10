resource "aws_iam_role" "terraform_role" { //erstellen einer IAM-Rolle für Terraform, um die notwendigen Berechtigungen für die Verwaltung der AWS-Ressourcen zu erhalten
  name = var.terraform_role_name

  assume_role_policy = jsonencode({ // Definition der Vertrauensrichtlinie für die IAM-Rolle, hier mit Bezug auf den IAM-Benutzer "AdminHeMaNe", der die Rolle annehmen darf, um die AWS-Ressourcen zu verwalten
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.terraform_admin_user_arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_poweruser" { // Anfügen der PowerUserAccess-Policy an die zuvor erstellte IAM-Rolle, um der Rolle die notwendigen Berechtigungen für die Verwaltung der AWS-Ressourcen zu gewähren
  role = aws_iam_role.terraform_role.name
  policy_arn = var.policy_poweruser_arn
}

resource "aws_iam_role" "github_role" { // Erstellen einer IAM-Rolle für GitHub Actions, um die notwendigen Berechtigungen für die Bereitstellung in S3 und die Invalidation von CloudFront-Distributionen zu erhalten
  name = var.github_role_name

  assume_role_policy = jsonencode({ // Definition der Vertrauensrichtlinie für die IAM-Rolle, hier mit Bezug auf den OIDC-Provider von GitHub Actions und die Bedingungen, unter denen die Rolle angenommen werden darf
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { // Definition des Principals, hier mit Bezug auf den OIDC-Provider von GitHub Actions, um die Rolle für die GitHub Actions verfügbar zu machen
          Federated = var.github_oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity" // Aktion, die erlaubt, die Rolle mit Web Identity anzunehmen, hier notwendig für die Integration mit GitHub Actions
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*" // Bedingung, die sicherstellt, dass nur GitHub Actions aus dem Repository "Cynd3r3ll4/Cloud-Programming-Code" die Rolle annehmen können, um die Sicherheit zu gewährleisten
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com" // Bedingung, die sicherstellt, dass der Audience-Claim im OIDC-Token mit "sts.amazonaws.com" übereinstimmt, um die Sicherheit zu gewährleisten
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_cf_invalidation" { // Erstellen einer benutzerdefinierten IAM-Policy für die Invalidation von CloudFront-Distributionen, um GitHub Actions die Berechtigung zu geben, die CloudFront Distribution zu invalidieren, wenn neue Inhalte bereitgestellt werden
  name = "GitHubActionsCloudFrontInvalidation"
  description = "Erlaubt GitHub Actions das Invalidieren der CloudFront Distribution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0"
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation" // Berechtigung zum Erstellen von Invalidierungen in der CloudFront Distribution, um sicherzustellen, dass die neuesten Inhalte nach der Bereitstellung in S3 sofort verfügbar sind
        ]
        Resource = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.website.id}" // Nutzung von Variablen für die Account ID und die CloudFront Distribution ID, um die Berechtigungen auf die spezifische CloudFront Distribution zu beschränken, die von diesem Projekt verwendet wird, um die Sicherheit zu gewährleisten
      }
    ]
  })
}

resource "aws_iam_policy" "github_s3_deploy" { // Erstellen einer benutzerdefinierten IAM-Policy für die Bereitstellung in S3, um GitHub Actions die Berechtigung zu geben, Inhalte in den S3 Bucket hochzuladen und zu löschen, wenn neue Inhalte bereitgestellt werden
  name = "GitHubActionsS3Deploy"
  description = "Erlaubt GitHub Actions das Deployen in den S3 Bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0"
        Effect = "Allow"
        Action = [ // Berechtigungen für die Aktionen, die zum Hochladen, Löschen und Auflisten von Objekten im S3 Bucket erforderlich sind, um die Bereitstellung von Inhalten zu ermöglichen
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket.website.arn}",
          "${aws_s3_bucket.website.arn}/*"
        ]
      }
    ]
  })
}

// Anfügen der GitHubActionsS3Deploy-Policy an die GitHubRolle, um den GitHub Actions die Berechtigungen für die Bereitstellung in S3 zu gewähren
resource "aws_iam_role_policy_attachment" "github_s3_deploy_attach" {
  role = aws_iam_role.github_role.name
  policy_arn = aws_iam_policy.github_s3_deploy.arn
}

// Anfügen der GitHubActionsCloudFrontInvalidation-Policy an die GitHubRolle, um den GitHub Actions die Berechtigungen für die Invalidation der CloudFront Distribution zu gewähren
resource "aws_iam_role_policy_attachment" "github_cf_invalidation_attach" {
  role = aws_iam_role.github_role.name
  policy_arn = aws_iam_policy.github_cf_invalidation.arn
}
