// Variablen für provider.tf
variable "aws_region" {
    description = "AWS Region für den Hauptprovider"
    type = string
    default = "eu-central-1"
}

variable "aws_secondary_region" {
    description = "AWS Region für den sekundären Provider (SNS / CloudWatch Alarme)"
    type = string
    default = "us-east-1"
}

// Variablen für s3.tf
variable "bucket_name" {
    description = "Name des S3 Buckets (auch Origin für CloudFront)"
    type = string
    default = "cloud-programming-bucket-cynd3r3ll4"
}

variable "s3_region" {
    description = "Region für die S3 Origin-Domain in CloudFront"
    type = string
    default = "eu-central-1"
}

variable "s3_sse_algorithm" {
    description = "Server-side Encryption Algorithmus für S3"
    type = string
    default = "AES256"
}

// Variablen für s3.tf Staging
variable "bucket_name_staging" {
    description = "Name des S3 Staging-Buckets"
    type = string
    default = "cloud-programming-bucket-cynd3r3ll4-staging"
}

// Variablen für cloudfront.tf (und s3.tf)
variable "cloudfront_default_root_object" {
    description = "Standard-Root-Objekt für die CloudFront Distribution"
    type = string
    default = "index.html"
}

variable "cloudfront_http_version" {
    description = "HTTP-Version für die CloudFront Distribution"
    type = string
    default = "http2and3"
}

variable "cloudfront_viewer_protocol_policy" {
    description = "Viewer Protocol Policy für die CloudFront Distribution"
    type = string
    default = "redirect-to-https"
}

variable "cloudfront_allowed_methods" {
    description = "Erlaubte HTTP-Methoden für das CloudFront Default Cache Behavior"
    type = list(string)
    default = ["GET", "HEAD"]
}

variable "cloudfront_cached_methods" {
    description = "Gecachte HTTP-Methoden für das CloudFront Default Cache Behavior"
    type = list(string)
    default = ["GET", "HEAD"]
}

variable "cloudfront_comment" {
    description = "Kommentar / Name der CloudFront Distribution"
    type = string
    default = "Cynd3r3ll4 Couture Distribution"
}

variable "cloudfront_price_class" {
    description = "CloudFront Price Class"
    type = string
    default = "PriceClass_All" // Alle Preisstufen, um die Verteilung in allen Regionen zu ermöglichen
}

variable "cache_policy_id" {
    description = "ID der CloudFront Cache Policy"
    type = string
    default = "658327ea-f89d-4fab-a63d-7e88639e58f6"
}

variable "cloudfront_tag_name" {
    description = "Tag Name für die CloudFront Distribution"
    type = string
    default = "Cynd3r3ll4 Couture"
}

// Variable für die OAC-Konfiguration in cloudfront.tf
variable "oac_name" {
    description = "Name der Origin Access Control"
    type = string
    default = "oac-cpc"
}

variable "oac_description" {
    description = "Beschreibung der OAC"
    type = string
    default = "OAC for S3 origin cloud-programming-bucket-cynd3r3ll4"
}

// Variablen für cloudwatch-alarme.tf
variable "alarm_threshold_4xx" {
    description = "Schwellenwert für 4xx Fehlerquote in Prozent"
    type = number
    default = 5
}

variable "alarm_threshold_5xx" {
    description = "Schwellenwert für 5xx Fehlerquote in Prozent"
    type = number
    default = 1
}

variable "alarm_threshold_requests" {
    description = "Schwellenwert für die Anzahl der Requests in 5 Minuten"
    type = number
    default = 1000
}

variable "alarm_name_4xx" {
    description = "Name des 4xx CloudWatch Alarms"
    type = string
    default = "4xx-CloudWatch-Alarm"
}

variable "alarm_name_5xx" {
    description = "Name des 5xx CloudWatch Alarms"
    type = string
    default = "5xx-CloudWatch-Alarm"
}

variable "alarm_name_requests" {
    description = "Name des Requests CloudWatch Alarms"
    type = string
    default = "Requests-CloudWatch-Alarm"
}

// Variablen für cloudwatch-dashboard.tf
variable "cloudwatch_dashboard_name" {
    description = "Name für das CloudWatch Dashboard"
    type = string
    default = "Website-Monitoring-Dashboard"
}

variable "cloudwatch_dashboard_region" {
    description = "Region für das CloudWatch Dashboard"
    type = string
    default = "eu-central-1"
}

variable "cloudwatch_metrics_region" {
    description = "Region für CloudWatch Metriken und SNS-Topic-Metriken"
    type = string
    default = "us-east-1"
}

// Variablen für iam.tf
// Terraform Rolle
variable "terraform_role_name" {
    description = "Name der Terraform IAM Rolle"
    type = string
    default = "TerraformRolle"
}

variable "terraform_admin_user_arn" {
    description = "ARN des IAM Users, der die Terraform Rolle annehmen darf"
    type = string
    default = "arn:aws:iam::855763870022:user/AdminHeMaNe"
}

variable "policy_poweruser_arn" {
    description = "ARN der PowerUserAccess IAM-Policy für die Terraform-Rolle"
    type = string
    default = "arn:aws:iam::aws:policy/PowerUserAccess"
}

//GitHub Rolle
variable "github_role_name" {
    description = "Name der GitHub Actions IAM Rolle"
    type = string
    default = "GitHubRolle"
}

variable "github_oidc_provider_arn" {
    description = "ARN des GitHub OIDC Providers"
    type = string
    default = "arn:aws:iam::855763870022:oidc-provider/token.actions.githubusercontent.com"
}

variable "github_repo" {
        description = "Liste der erlaubten OIDC 'sub' Patterns für GitHub (StringLike)\n    Beispiele: 'repo:owner@*/repo@*:environment:staging' oder 'repo:owner/repo:ref:refs/heads/*'"
        type = list(string)
        default = [
            "repo:Cynd3r3ll4@*/Cynd3r3ll4-Couture@*:environment:staging",
            "repo:Cynd3r3ll4@*/Cynd3r3ll4-Couture@*:environment:production",
            "repo:Cynd3r3ll4@*/Cynd3r3ll4-Couture@*:ref:refs/heads/*",
            "repo:Cynd3r3ll4/Cynd3r3ll4-Couture:environment:staging",
            "repo:Cynd3r3ll4/Cynd3r3ll4-Couture:environment:production",
            "repo:Cynd3r3ll4/Cynd3r3ll4-Couture:ref:refs/heads/*",
            "repo:cynd3r3ll4@*/cynd3r3ll4-couture@*:environment:staging",
            "repo:cynd3r3ll4@*/cynd3r3ll4-couture@*:environment:production",
            "repo:cynd3r3ll4@*/cynd3r3ll4-couture@*:ref:refs/heads/*",
            "repo:cynd3r3ll4/cynd3r3ll4-couture:environment:staging",
            "repo:cynd3r3ll4/cynd3r3ll4-couture:environment:production",
            "repo:cynd3r3ll4/cynd3r3ll4-couture:ref:refs/heads/*"
        ]
}