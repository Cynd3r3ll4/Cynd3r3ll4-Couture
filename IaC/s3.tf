resource "aws_s3_bucket" "website" { // Art der Ressource: S3 Bucket + interner Name: website
  bucket = var.bucket_name           // S3 Bucket Name
}

resource "aws_s3_bucket_public_access_block" "website" { // Art der Konfiguration: Public Access Block + interner Name: website
  bucket = aws_s3_bucket.website.id                      // Verknüpfung mit meinem S3 Bucket über die ID des Buckets

  block_public_acls       = true // keine Access Control Lists erlaubt, die öffentliche Zugriffe erlauben
  block_public_policy     = true // keine Bucket-Policies erlaubt, die öffentliche Zugriffe erlauben
  ignore_public_acls      = true // Alle ACLs, die öffentliche Zugriffe erlauben, werden ignoriert
  restrict_public_buckets = true // erzwingt, dass der Bucket nicht öffentlich zugänglich ist, selbst wenn eine Bucket-Policy dies erlaubt
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website" { //Art der Verschlüsselungskonfiguration: Server Side Encryption + interner Name: website
  bucket = aws_s3_bucket.website.id

  rule {                                      //Verschlüsselungsregel
    apply_server_side_encryption_by_default { //standardmäßige Verschlüsselungseinstellung
      sse_algorithm = var.s3_sse_algorithm    //Standardverschlüsselungsalgorithmus für S3
    }
  }
}

resource "aws_s3_bucket_policy" "website_policy" { // Art der Bucket-Policy-Konfiguration: S3 Bucket Policy + interner Name: website_policy
  bucket = aws_s3_bucket.website.id                // Verknüpfung mit meinem S3 Bucket über die ID des Buckets

  policy = jsonencode({    // JSON-kodierte Bucket-Policy, die den Zugriff von CloudFront auf den S3 Bucket erlaubt
    Version = "2012-10-17" // Version der Policy-Syntax, hier die aktuelle Version
    Statement = [          // Array von Anweisungen, hier nur eine Anweisung, die den Zugriff von CloudFront erlaubt
      {
        Sid    = "AllowCloudFrontOAC"          // Anweisungs-ID, hier mit Bezug zur Erlaubnis für CloudFront Origin Access Control
        Effect = "Allow"                       // Effekt der Anweisung, hier "Allow", um den Zugriff zu erlauben
        Principal = {                          // Definition des Principlas (der Entität, die Zugriff erhält)
          Service = "cloudfront.amazonaws.com" // Service, der Zugriff erhält, hier CloudFront, um den Zugriff von CloudFront zu erlauben
        }
        Action   = "s3:GetObject"                             // Erlaubte Aktion, hier GetObject, nur lesender Zugriff, keine Schreib- oder Löschrechte
        Resource = "${aws_s3_bucket.website.arn}/*"           // Ressource, auf die zugegriffen werden kann, nur die Objekte, nicht der Bucket selbst
        Condition = {                                         // Einschränkungsbedingung, um den Zugriff weiter einzuschränken
          StringEquals = {                                    // Bedingungstyp, hier StringEquals, um den Zugriff auf Anfragen von einer bestimmten CloudFront Distribution zu beschränken
            "AWS:SourceArn" = var.cloudfront_distribution_arn // ARN der CloudFront Distribution
          }
        }
      }
    ]
  })
}