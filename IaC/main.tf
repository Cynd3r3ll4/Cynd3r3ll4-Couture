/*
  Dieses Terraform-Projekt ist modular aufgebaut.
  Alle Ressourcen sind in separaten Dateien organisiert:

  - provider.tf             → Provider-Konfiguration (AWS)
  - s3.tf                   → S3 Bucket
  - cloudfront.tf           → CloudFront Distribution + OAC
  - iam.tf                  → IAM Rollen/Policies
  - cloudwatch-alarme.tf    → CloudWatch Alarme
  - cloudwatch-dashboard.tf → CloudWatch Dashboard
  - sns.tf                  → SNS Topics
  - variables.tf            → Eingabevariablen
  - outputs.tf              → Ausgaben

  Die main.tf dient nur als Einstiegspunkt und enthält keine Ressourcen.
*/