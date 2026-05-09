// 4xx-CloudWatch-Alarm für die Fehlerquote von 4xx-Fehlern in der CloudFront Distribution, hier mit einem Schwellenwert von 5%, um eine Benachrichtigung auszulösen, wenn die Fehlerquote ungewöhnlich hoch ist
resource "aws_cloudwatch_metric_alarm" "cf_4xx_alarm" {
    provider = aws.us_east_1 // Angabe des Providers für die CloudWatch Alarme, damit sie die SNS-Topics in der Region us-east-1 erreichen können, da CloudWatch Alarme nur SNS-Topics in der Region us-east-1 als Alarmaktionen unterstützen
    alarm_name = var.alarm_name_4xx // Name des CloudWatch Alarms, hier mit Bezug zu den 4xx-Fehlern der CloudFront Distribution
    comparison_operator = "GreaterThanThreshold" // Vergleichsoperator, hier "GreaterThanThreshold", um eine Benachrichtigung auszulösen, wenn die Fehlerquote den Schwellenwert überschreitet
    evaluation_periods  = 1 // Anzahl der Bewertungsperioden, hier 1, um sofort eine Benachrichtigung auszulösen, wenn die Fehlerquote den Schwellenwert überschreitet
    threshold = var.alarm_threshold_4xx // Schwellenwert für die Fehlerquote, hier 5%, um eine Benachrichtigung auszulösen, wenn die Fehlerquote ungewöhnlich hoch ist
    metric_name = "4xxErrorRate" // Name der Metrik, hier "4xxErrorRate", um die Fehlerquote von 4xx-Fehlern in der CloudFront Distribution zu überwachen
    namespace = "AWS/CloudFront" // Namespace der Metrik, hier "AWS/CloudFront", um die Metrik der CloudFront Distribution zuzuordnen
    period = 300 // Berechnung der Metrik alle 5 Minuten (300 Sekunden), um eine zeitnahe Überwachung der Fehlerquote zu ermöglichen
    statistic = "Average" // Verwendung des Durchschnitts als Statistik, um die durchschnittliche Fehlerquote über den angegebenen Zeitraum zu überwachen

    dimensions = { // Definition der Dimensionen für die Metrik, hier mit Bezug zur CloudFront Distribution über die DistributionId und die Region
        DistributionId = var.cloudfront_distribution_id
        Region = "Global"
  }

    alarm_description = "Alarm when CloudFront 4xx error rate exceeds 5%"
    alarm_actions = [aws_sns_topic.cf_4xx_alarm.arn]
}

// 5xx-CloudWatch-Alarm für die Fehlerquote von 5xx-Fehlern in der CloudFront Distribution, hier mit einem Schwellenwert von 1%, um eine Benachrichtigung auszulösen, wenn die Fehlerquote ungewöhnlich hoch ist
resource "aws_cloudwatch_metric_alarm" "cf_5xx_alarm" {
    provider = aws.us_east_1
    alarm_name = var.alarm_name_5xx
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 1
    threshold = var.alarm_threshold_5xx
    metric_name = "5xxErrorRate"
    namespace = "AWS/CloudFront"
    period = 300
    statistic = "Average"

    dimensions = {
        DistributionId = var.cloudfront_distribution_id
        Region = "Global"
  }

    alarm_description = "Alarm when CloudFront 5xx error rate exceeds 1%"
    alarm_actions = [aws_sns_topic.cf_5xx_alarm.arn]
}

// Request-CloudWatch-Alarm für die Anzahl der Anfragen an die CloudFront Distribution, hier mit einem Schwellenwert von 1000 Anfragen in einem 5-Minuten-Zeitraum, um eine Benachrichtigung auszulösen, wenn die Anzahl der Anfragen ungewöhnlich hoch ist
resource "aws_cloudwatch_metric_alarm" "cf_requests_alarm" {
    provider = aws.us_east_1
    alarm_name = var.alarm_name_requests
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 1
    threshold = var.alarm_threshold_requests
    metric_name = "Requests"
    namespace = "AWS/CloudFront"
    period = 300
    statistic = "Average"

    dimensions = {
        DistributionId = var.cloudfront_distribution_id
        Region = "Global"
  }

    alarm_description = "Alarm when CloudFront requests exceed 1000 in a 5-minute period"
    alarm_actions = [aws_sns_topic.requests_alarm.arn]
}