resource "aws_cloudwatch_dashboard" "website_monitoring" {
  dashboard_name = var.cloudwatch_dashboard_name

  dashboard_body = jsonencode({
    widgets = [

      // 4xxErrorRate
      {
        "type" : "metric",                            // Widget-Typ: Metrik, um die 4xx-Fehlerquote der CloudFront Distribution zu überwachen
        "width" : 6,                                  // Breite des Widgets, hier 6 von 12 möglichen Einheiten, um es neben anderen Widgets anzuzeigen
        "height" : 3,                                 // Höhe des Widgets, hier 3 Einheiten, um eine kompakte Darstellung zu ermöglichen
        "properties" : {                              // Eigenschaften des Widgets, hier mit Fokus auf die 4xx-Fehlerquote
          "view" : "singleValue",                     // Ansichtstyp: Single Value, um die aktuelle Fehlerquote als einzelne Zahl anzuzeigen
          "stacked" : true,                           // Aktivierung der Stapelung, um die 4xx-Fehlerquote im Kontext anderer Metriken anzuzeigen, falls vorhanden
          "region" : var.cloudwatch_dashboard_region, // Region der Metrik, hier eu-central-1, um die Daten aus der richtigen Region zu beziehen
          "period" : 300,                             // Berechnung der Metrik alle 5 Minuten (300 Sekunden), um eine zeitnahe Überwachung der Fehlerquote zu ermöglichen
          "stat" : "Average",                         // Verwendung des Durchschnitts als Statistik, um die durchschnittliche Fehlerquote über den angegebenen Zeitraum zu überwachen
          "metrics" : [                               // Definition der Metrik, hier die 4xxErrorRate der CloudFront Distribution mit der entsprechenden DistributionId und Region
            ["AWS/CloudFront", "4xxErrorRate", "Region", "Global", "DistributionId", "${aws_cloudfront_distribution.website.id}", { "region" : var.cloudwatch_metrics_region }]
          ]
        }
      },

      // 5xxErrorRate
      {
        "type" : "metric",
        "width" : 6,
        "height" : 3,
        "properties" : {
          "view" : "singleValue",
          "sparkline" : true,
          "region" : var.cloudwatch_dashboard_region,
          "period" : 300,
          "stat" : "Average",
          "metrics" : [
            ["AWS/CloudFront", "5xxErrorRate", "Region", "Global", "DistributionId", "${aws_cloudfront_distribution.website.id}", { "region" : var.cloudwatch_metrics_region }]
          ]
        }
      },

      // Total Error Rate
      {
        "type" : "metric",
        "width" : 6,
        "height" : 3,
        "properties" : {
          "view" : "singleValue",
          "stacked" : true,
          "region" : var.cloudwatch_dashboard_region,
          "period" : 300,
          "stat" : "Average",
          "metrics" : [
            ["AWS/CloudFront", "TotalErrorRate", "Region", "Global", "DistributionId", "${aws_cloudfront_distribution.website.id}", { "region" : var.cloudwatch_metrics_region }]
          ]
        }
      },

      // Requests-CloudWatch-Alarm
      {
        "type" : "metric",
        "width" : 6,
        "height" : 6,
        "properties" : {
          "view" : "pie",
          "region" : var.cloudwatch_dashboard_region,
          "period" : 300,
          "title" : "Requests-CloudWatch-Alarme",
          "metrics" : [
            ["AWS/SNS", "NumberOfNotificationsFailed", "TopicName", "${var.alarm_name_requests}", { "region" : var.cloudwatch_metrics_region }],
            [".", "NumberOfNotificationsDelivered", ".", ".", { "region" : var.cloudwatch_metrics_region }]
          ]
        }
      },

      // 5xx-CloudWatch-Alarm
      {
        "type" : "metric",
        "width" : 6,
        "height" : 6,
        "properties" : {
          "view" : "pie",
          "region" : var.cloudwatch_dashboard_region,
          "period" : 300,
          "title" : "5xx-CloudWatch-Alarme",
          "metrics" : [
            ["AWS/SNS", "NumberOfNotificationsDelivered", "TopicName", "${var.alarm_name_5xx}", { "region" : var.cloudwatch_metrics_region }],
            [".", "NumberOfNotificationsFailed", ".", ".", { "region" : var.cloudwatch_metrics_region }]
          ]
        }
      },

      // 4xx-CloudWatch-Alarm
      {
        "type" : "metric",
        "width" : 6,
        "height" : 6,
        "properties" : {
          "view" : "pie",
          "region" : var.cloudwatch_dashboard_region,
          "period" : 300,
          "title" : "4xx-CloudWatch-Alarme",
          "metrics" : [
            ["AWS/SNS", "NumberOfNotificationsDelivered", "TopicName", "${var.alarm_name_4xx}", { "region" : var.cloudwatch_metrics_region }],
            [".", "NumberOfNotificationsFailed", ".", ".", { "region" : var.cloudwatch_metrics_region }]
          ]
        }
      },

      // Requests
      {
        "type" : "metric",
        "width" : 12,
        "height" : 6,
        "properties" : {
          "view" : "timeSeries",
          "stacked" : false,
          "region" : var.cloudwatch_dashboard_region,
          "period" : 300,
          "title" : "Requests",
          "stat" : "Average",
          "metrics" : [
            ["AWS/CloudFront", "Requests", "Region", "Global", "DistributionId", "${aws_cloudfront_distribution.website.id}", { "region" : var.cloudwatch_metrics_region }]
          ]
        }
      }
    ]
  })
}
