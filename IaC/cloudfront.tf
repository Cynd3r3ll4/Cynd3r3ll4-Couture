resource "aws_cloudfront_distribution" "website" {
    enabled = true // Aktivierung der CloudFront Distribution, damit sie bereitgestellt und genutzt werden kann
    comment = var.cloudfront_comment // Kommentar zur Distribution
    is_ipv6_enabled = true // Aktivierung der Unterstützung für IPv6, um die Erreichbarkeit der Verteilung über das neuere Internetprotokoll zu gewährleisten
    http_version = var.cloudfront_http_version // Unterstützung für HTTP/2 und HTTP/3, um die Leistung und Effizienz der Verteilung zu verbessern
    default_root_object = var.cloudfront_default_root_object // Standard-Root-Objekt, das von der Verteilung bereitgestellt wird

  origin { // Ursprungsdefinition für die CloudFront Distribution
    domain_name = "${var.bucket_name}.s3.${var.s3_region}.amazonaws.com" // Domain Name meines S3 Buckets, hier mit Bezug zum Bucket Namen und der Region
    origin_id = "s3_origin" // Interne ID für diesen Ursprung, hier als s3_origin bezeichnet, weil CloudFront-interne ID nicht statisch ist und sich bei jeder Bereitstellung ändert
    origin_access_control_id = aws_cloudfront_origin_access_control.website_oac.id // Verknüpfung mit der definierten Origin Access Control über die ID der OAC
    connection_attempts = 3 // Anzahl der Verbindungsversuche, die CloudFront unternimmt, bevor es einen Fehler zurückgibt, hier 3 Versuche
    connection_timeout = 10 // Zeitlimit in Sekunden für die Herstellung einer Verbindung zum Ursprung, hier 10 Sekunden --> beides intern von CloudFront erstellt
  }

  default_cache_behavior {
    target_origin_id = "s3_origin" // Verknüpfung mit dem definierten Ursprung über die origin_id
    viewer_protocol_policy = var.cloudfront_viewer_protocol_policy // Richtlinie für die Protokollnutzung der Viewer

    allowed_methods = var.cloudfront_allowed_methods // Erlaubte HTTP-Methoden für die Verteilung
    cached_methods = var.cloudfront_cached_methods // HTTP-Methoden, die von CloudFront zwischengespeichert werden
    cache_policy_id = var.cache_policy_id // ID der Cache-Policy, hier wird die Standard-Cache-Policy von CloudFront verwendet, die eine effiziente Zwischenspeicherung ermöglicht
    compress = true // Aktivierung der Komprimierung von Inhalten, um die Übertragung zu optimieren
  }

  price_class = var.cloudfront_price_class // Preisstufe für die CloudFront Distribution

  restrictions {
    geo_restriction {
      restriction_type = "none" // Geografische Einschränkungen für die Verteilung, hier keine Einschränkungen, sodass die Verteilung weltweit zugänglich ist
    }
  }

  viewer_certificate { // Zertifikatskonfiguration für die Viewer, hier wird das Standardzertifikat von CloudFront verwendet
    cloudfront_default_certificate = true
  }

  tags = { // Tags für die CloudFront Distribution, hier mit einem Bezug zum Namen der Website
    Name = var.cloudfront_tag_name
  }
}

resource "aws_cloudfront_origin_access_control" "website_oac" { //Art der OAC-Konfiguration: CloudFront Origin Access Control + interner Name: website_oac
    name = var.oac_name              // Name der OAC, hier mit Bezug zum S3 Bucket und der Region
    description = var.oac_description       // Beschreibung der OAC, hier mit Bezug zum S3 Bucket
    origin_access_control_origin_type = "s3"                      // Arten der Ursprungsressource, hier S3
    signing_behavior = "always"                  // Signierverhalten der Requests, hier immer signieren
    signing_protocol = "sigv4"                   // Signierprotokoll, hier AWS Signature Version 4
  }

  resource "aws_cloudfront_distribution" "staging" { // Staging CloudFront-Distribution für sicheren Zugriff auf den Staging-Bucket
  enabled = true
  comment = "${var.cloudfront_comment} - Staging"
  is_ipv6_enabled = true
  http_version = var.cloudfront_http_version
  default_root_object = var.cloudfront_default_root_object

  origin {
    domain_name = "${aws_s3_bucket.staging.bucket}.s3.${var.s3_region}.amazonaws.com"
    origin_id = "s3_staging_origin"
    origin_access_control_id  = aws_cloudfront_origin_access_control.website_oac.id
    connection_attempts = 3
    connection_timeout = 10
  }

  default_cache_behavior {
    target_origin_id = "s3_staging_origin"
    viewer_protocol_policy  = var.cloudfront_viewer_protocol_policy
    allowed_methods = var.cloudfront_allowed_methods
    cached_methods = var.cloudfront_cached_methods
    cache_policy_id = var.cache_policy_id
    compress = true
  }

  price_class = "PriceClass_100" // günstiger --> Tests müssen nicht weltweit verteilt werden!

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "${var.cloudfront_tag_name} Staging"
  }
}