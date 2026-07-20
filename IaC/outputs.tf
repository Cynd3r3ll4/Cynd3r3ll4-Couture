//S3 Bucket Outputs
output "s3_bucket_name" {
    description = "Name des S3 Buckets"
    value = aws_s3_bucket.website.bucket
}

output "s3_bucket_arn" {
    description = "ARN des S3 Buckets"
    value = aws_s3_bucket.website.arn
}

// CloudFront Outputs
output "cloudfront_distribution_id" {
    description = "ID der CloudFront Distribution"
    value = aws_cloudfront_distribution.website.id
}

output "cloudfront_distribution_arn" {
    description = "ARN der CloudFront Distribution"
    value = aws_cloudfront_distribution.website.arn
}

output "cloudfront_domain_name" {
    description = "Domain Name der CloudFront Distribution"
    value = aws_cloudfront_distribution.website.domain_name
}

output "cloudfront_origin_access_control_id" {
    description = "ID der CloudFront Origin Access Control"
    value = aws_cloudfront_origin_access_control.website_oac.id
}

output "cloudfront_origin_access_control_arn" {
    description = "ARN der CloudFront Origin Access Control"
    value = aws_cloudfront_origin_access_control.website_oac.arn
}

// IAM Outputs
output "terraform_role_arn" {
    description = "ARN der Terraform IAM Rolle"
    value = aws_iam_role.terraform_role.arn
}

output "github_role_arn" {
    description = "ARN der GitHub Actions IAM Rolle"
    value = aws_iam_role.github_role.arn
}

// SNS Outputs
output "sns_topic_4xx_arn" {
    description = "ARN des 4xx SNS Topics"
    value = aws_sns_topic.cf_4xx_alarm.arn
}

output "sns_topic_5xx_arn" {
    description = "ARN des 5xx SNS Topics"
    value = aws_sns_topic.cf_5xx_alarm.arn
}

output "sns_topic_requests_arn" {
    description = "ARN des Requests SNS Topics"
    value = aws_sns_topic.requests_alarm.arn
}

// CloudWatch Alarm Outputs
output "cloudwatch_alarm_4xx_arn" {
    description = "ARN des CloudWatch 4xx Alarms"
    value = aws_cloudwatch_metric_alarm.cf_4xx_alarm.arn
}

output "cloudwatch_alarm_5xx_arn" {
    description = "ARN des CloudWatch 5xx Alarms"
    value = aws_cloudwatch_metric_alarm.cf_5xx_alarm.arn
}

output "cloudwatch_alarm_requests_arn" {
    description = "ARN des CloudWatch Requests Alarms"
    value = aws_cloudwatch_metric_alarm.cf_requests_alarm.arn
}

// CloudWatch Dashboard Outputs
output "cloudwatch_dashboard_name" {
    description = "Name des CloudWatch Dashboards"
    value = aws_cloudwatch_dashboard.website_monitoring.dashboard_name
}

// Staging Bucket Outputs
output "staging_website_url" {
  description = "CloudFront-URL der Staging-Vorschau"
  value       = aws_cloudfront_distribution.staging.domain_name
}

output "staging_cloudfront_distribution_id" {
  description = "ID der Staging-CloudFront-Distribution (für Cache-Invalidierung nötig)"
  value       = aws_cloudfront_distribution.staging.id
}