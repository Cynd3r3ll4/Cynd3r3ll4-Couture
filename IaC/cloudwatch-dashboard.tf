resource "aws_cloudwatch_dashboard" "website_monitoring" {
  dashboard_name = "Website-Monitoring-Dashboard"

  dashboard_body = jsonencode({
    widgets = [

      // 4xxErrorRate
      {
        "type" : "metric",           // Widget-Typ: Metrik, um die 4xx-Fehlerquote der CloudFront Distribution zu überwachen
        "width" : 6,                 // Breite des Widgets, hier 6 von 12 möglichen Einheiten, um es neben anderen Widgets anzuzeigen
        "height" : 3,                // Höhe des Widgets, hier 3 Einheiten, um eine kompakte Darstellung zu ermöglichen
        "properties" : {             // Eigenschaften des Widgets, hier mit Fokus auf die 4xx-Fehlerquote
          "view" : "singleValue",    // Ansichtstyp: Single Value, um die aktuelle Fehlerquote als einzelne Zahl anzuzeigen
          "stacked" : true,          // Aktivierung der Stapelung, um die 4xx-Fehlerquote im Kontext anderer Metriken anzuzeigen, falls vorhanden
          "region" : "eu-central-1", // Region der Metrik, hier eu-central-1, um die Daten aus der richtigen Region zu beziehen
          "period" : 300,            // Berechnung der Metrik alle 5 Minuten (300 Sekunden), um eine zeitnahe Überwachung der Fehlerquote zu ermöglichen
          "stat" : "Average",        // Verwendung des Durchschnitts als Statistik, um die durchschnittliche Fehlerquote über den angegebenen Zeitraum zu überwachen
          "metrics" : [              // Definition der Metrik, hier die 4xxErrorRate der CloudFront Distribution mit der entsprechenden DistributionId und Region
            ["AWS/CloudFront", "4xxErrorRate", "Region", "Global", "DistributionId", "E2ULZ1035XHSSW", { "region" : "us-east-1" }]
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
          "region" : "eu-central-1",
          "period" : 300,
          "stat" : "Average",
          "metrics" : [
            ["AWS/CloudFront", "5xxErrorRate", "Region", "Global", "DistributionId", "E2ULZ1035XHSSW", { "region" : "us-east-1" }]
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
          "region" : "eu-central-1",
          "period" : 300,
          "stat" : "Average",
          "metrics" : [
            ["AWS/CloudFront", "TotalErrorRate", "Region", "Global", "DistributionId", "E2ULZ1035XHSSW", { "region" : "us-east-1" }]
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
          "region" : "eu-central-1",
          "period" : 300,
          "title" : "Requests-CloudWatch-Alarme",
          "metrics" : [
            ["AWS/SNS", "NumberOfNotificationsFailed", "TopicName", "Requests-CloudWatch-Alarm", { "region" : "us-east-1" }],
            [".", "NumberOfNotificationsDelivered", ".", ".", { "region" : "us-east-1" }]
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
          "region" : "eu-central-1",
          "period" : 300,
          "title" : "5xx-CloudWatch-Alarme",
          "metrics" : [
            ["AWS/SNS", "NumberOfNotificationsDelivered", "TopicName", "5xx-CloudWatch-Alarm", { "region" : "us-east-1" }],
            [".", "NumberOfNotificationsFailed", ".", ".", { "region" : "us-east-1" }]
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
          "region" : "eu-central-1",
          "period" : 300,
          "title" : "4xx-CloudWatch-Alarme",
          "metrics" : [
            ["AWS/SNS", "NumberOfNotificationsDelivered", "TopicName", "4xx-CloudWatch-Alarm", { "region" : "us-east-1" }],
            [".", "NumberOfNotificationsFailed", ".", ".", { "region" : "us-east-1" }]
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
          "region" : "eu-central-1",
          "period" : 300,
          "title" : "Requests",
          "stat" : "Average",
          "metrics" : [
            ["AWS/CloudFront", "Requests", "Region", "Global", "DistributionId", "E2ULZ1035XHSSW", { "region" : "us-east-1" }]
          ]
        }
      },

      // Top URLs (Log Insights)
      {
        "type" : "log", // Widget-Typ: Log, um die Top-URLs der CloudFront Distribution basierend auf den Access Logs zu analysieren
        "width" : 12,
        "height" : 6,
        "properties" : {
          "region" : "eu-central-1",
          "query" : "fields csUriStem | stats count(*) as hits by csUriStem | sort hits desc | limit 10", // Log Insights Query, um die Top-URLs zu ermitteln, hier werden die csUriStem-Felder gezählt und nach Anzahl der Hits sortiert, um die 10 meistbesuchten URLs anzuzeigen
          "logGroupNames" : ["CloudFront-Access-Logs"],                                                   // Log-Gruppe, aus der die Access Logs der CloudFront Distribution stammen, hier mit Bezug zum Namen der Log-Gruppe
          "view" : "bar"
        }
      },

      // Requests pro Tag (Log Insights)
      {
        "type" : "log",
        "width" : 12,
        "height" : 6,
        "properties" : {
          "region" : "eu-central-1",
          "query" : "stats count(*) as requests by bin(1d)", // Log Insights Query, um die Anzahl der Requests pro Tag zu ermitteln, hier werden die Logs in 1-Tages-Intervalle gruppiert und die Anzahl der Requests gezählt
          "logGroupNames" : ["CloudFront-Access-Logs"],
          "view" : "bar"
        }
      },

      // Fehleranalyse (Log Insights)
      {
        "type" : "log",
        "width" : 12,
        "height" : 6,
        "properties" : {
          "region" : "eu-central-1",
          "query" : "fields @timestamp, csUriStem, status | filter status >= 400 | sort @timestamp desc | limit 20", // Log Insights Query, um die Fehleranalyse durchzuführen, hier werden die Logs gefiltert, um nur Einträge mit einem Statuscode von 400 oder höher anzuzeigen, sortiert nach Zeitstempel in absteigender Reihenfolge und auf die 20 neuesten Fehler begrenzt
          "logGroupNames" : ["CloudFront-Access-Logs"],
          "view" : "table"
        }
      }
    ]
  })
}
