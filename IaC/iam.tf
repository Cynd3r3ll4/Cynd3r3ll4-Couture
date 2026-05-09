resource "aws_iam_role" "terraform_role" { //erstellen einer IAM-Rolle für Terraform, um die notwendigen Berechtigungen für die Verwaltung der AWS-Ressourcen zu erhalten
    name = "TerraformRolle"

    assume_role_policy = jsonencode({ // Definition der Vertrauensrichtlinie für die IAM-Rolle, hier mit Bezug auf den IAM-Benutzer "AdminHeMaNe", der die Rolle annehmen darf, um die AWS-Ressourcen zu verwalten
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Principal = {
            AWS = "arn:aws:iam::855763870022:user/AdminHeMaNe"
            }
            Action = "sts:AssumeRole"
        }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "terraform_poweruser" { // Anfügen der PowerUserAccess-Policy an die zuvor erstellte IAM-Rolle, um der Rolle die notwendigen Berechtigungen für die Verwaltung der AWS-Ressourcen zu gewähren
    role       = aws_iam_role.terraform_role.name
    policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role" "github_role" { // Erstellen einer IAM-Rolle für GitHub Actions, um die notwendigen Berechtigungen für die Bereitstellung in S3 und die Invalidation von CloudFront-Distributionen zu erhalten
    name = "GitHubRolle"

    assume_role_policy = jsonencode({ // Definition der Vertrauensrichtlinie für die IAM-Rolle, hier mit Bezug auf den OIDC-Provider von GitHub Actions und die Bedingungen, unter denen die Rolle angenommen werden darf
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Principal = { // Definition des Principals, hier mit Bezug auf den OIDC-Provider von GitHub Actions, um die Rolle für die GitHub Actions verfügbar zu machen
            Federated = "arn:aws:iam::855763870022:oidc-provider/token.actions.githubusercontent.com"
            }
        Action = "sts:AssumeRoleWithWebIdentity" // Aktion, die erlaubt, die Rolle mit Web Identity anzunehmen, hier notwendig für die Integration mit GitHub Actions
            Condition = {
            StringLike = {
                "token.actions.githubusercontent.com:sub" = "repo:Cynd3r3ll4/Cloud-Programming-Code:*" // Bedingung, die sicherstellt, dass nur GitHub Actions aus dem Repository "Cynd3r3ll4/Cloud-Programming-Code" die Rolle annehmen können, um die Sicherheit zu gewährleisten
            }
            StringEquals = {
                "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com" // Bedingung, die sicherstellt, dass der Audience-Claim im OIDC-Token mit "sts.amazonaws.com" übereinstimmt, um die Sicherheit zu gewährleisten
            }
            }
        }
        ]
    })
}
// bestehende Policies für die GitHub Actions, hier mit Bezug auf die Berechtigungen für die Bereitstellung in S3 und die Invalidation von CloudFront-Distributionen, werden über Data Sources abgerufen und an die GitHubRolle angehängt, um den GitHub Actions die notwendigen Berechtigungen zu gewähren
data "aws_iam_policy" "github_s3_deploy" {
     arn = "arn:aws:iam::855763870022:policy/GitHubActionsS3Deploy"
}

data "aws_iam_policy" "github_cf_invalidation" {
    arn = "arn:aws:iam::855763870022:policy/GitHubActionsCloudFrontInvalidation"
}

// Anfügen der GitHubActionsS3Deploy-Policy an die GitHubRolle, um den GitHub Actions die Berechtigungen für die Bereitstellung in S3 zu gewähren
resource "aws_iam_role_policy_attachment" "github_s3_deploy_attach" {
    role       = aws_iam_role.github_role.name
    policy_arn = data.aws_iam_policy.github_s3_deploy.arn
}

resource "aws_iam_role_policy_attachment" "github_cf_invalidation_attach" {
    role       = aws_iam_role.github_role.name
    policy_arn = data.aws_iam_policy.github_cf_invalidation.arn
}
