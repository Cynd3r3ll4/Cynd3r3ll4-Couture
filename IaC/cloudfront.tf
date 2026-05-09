resource "aws_cloudfront_distribution" "website" {
  enabled             = true                              // Aktivierung der CloudFront Distribution, damit sie bereitgestellt und genutzt werden kann
  comment             = "Cynd3r3ll4 Couture Distribution" // Kommentar zur Distribution, hier mit Bezug zum Namen der Website
  is_ipv6_enabled     = true                              // Aktivierung der Unterstützung für IPv6, um die Erreichbarkeit der Verteilung über das neuere Internetprotokoll zu gewährleisten
  http_version        = "http2and3"                       // Unterstützung für HTTP/2 und HTTP/3, um die Leistung und Effizienz der Verteilung zu verbessern
  default_root_object = "index.html"                      // Standard-Root-Objekt, das von der Verteilung bereitgestellt wird, hier index.html

  origin {                                                                                         // Ursprungsdefinition für die CloudFront Distribution
    domain_name              = "cloud-programming-bucket-cynd3r3ll4.s3.eu-central-1.amazonaws.com" // Domain Name meines S3 Buckets, hier mit Bezug zum Bucket Namen und der Region
    origin_id                = "s3_origin"                                                         // Interne ID für diesen Ursprung, hier als s3_origin bezeichnet, weil CloudFront-interne ID nicht statisch ist und sich bei jeder Bereitstellung ändert
    origin_access_control_id = aws_cloudfront_origin_access_control.website_oac.id                 // Verknüpfung mit der definierten Origin Access Control über die ID der OAC
    connection_attempts      = 3                                                                   // Anzahl der Verbindungsversuche, die CloudFront unternimmt, bevor es einen Fehler zurückgibt, hier 3 Versuche
    connection_timeout       = 10                                                                  // Zeitlimit in Sekunden für die Herstellung einer Verbindung zum Ursprung, hier 10 Sekunden --> beides intern von CloudFront erstellt
  }

  default_cache_behavior {
    target_origin_id       = "s3_origin"         // Verknüpfung mit dem definierten Ursprung über die origin_id
    viewer_protocol_policy = "redirect-to-https" // Richtlinie für die Protokollnutzung der Viewer, hier werden HTTP-Anfragen automatisch auf HTTPS umgeleitet

    allowed_methods = ["GET", "HEAD"]                        // Erlaubte HTTP-Methoden für die Verteilung, hier GET und HEAD
    cached_methods  = ["GET", "HEAD"]                        // HTTP-Methoden, die von CloudFront zwischengespeichert werden, hier ebenfalls GET und HEAD
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" // ID der Cache-Policy, hier wird die Standard-Cache-Policy von CloudFront verwendet, die eine effiziente Zwischenspeicherung ermöglicht
    compress        = true                                   // Aktivierung der Komprimierung von Inhalten, um die Übertragung zu optimieren
  }

  price_class = "PriceClass_All" // Preisstufe für die CloudFront Distribution, hier wird die höchste Stufe gewählt, um die Verteilung in allen Regionen zu ermöglichen

  restrictions {
    geo_restriction {
      restriction_type = "none" // Geografische Einschränkungen für die Verteilung, hier keine Einschränkungen, sodass die Verteilung weltweit zugänglich ist
    }
  }

  viewer_certificate { // Zertifikatskonfiguration für die Viewer, hier wird das Standardzertifikat von CloudFront verwendet
    cloudfront_default_certificate = true
  }

  tags = { // Tags für die CloudFront Distribution, hier mit einem Bezug zum Namen der Website
    Name = "Cynd3r3ll4 Couture"
  }
}

resource "aws_cloudfront_origin_access_control" "website_oac" {                                          //Art der OAC-Konfiguration: CloudFront Origin Access Control + interner Name: website_oac
  name                              = "oac-cloud-programming-bucket-cynd3r3ll4.s3.eu-centra-moondf4189o" // Name der OAC, hier mit Bezug zum S3 Bucket und der Region
  description                       = "OAC for S3 origin cloud-programming-bucket-cynd3r3ll4"            // Beschreibung der OAC, hier mit Bezug zum S3 Bucket
  origin_access_control_origin_type = "s3"                                                               // Arten der Ursprungsressource, hier S3
  signing_behavior                  = "always"                                                           // Signierverhalten der Requests, hier immer signieren
  signing_protocol                  = "sigv4"                                                            // Signierprotokoll, hier AWS Signature Version 4
}