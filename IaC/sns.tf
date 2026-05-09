resource "aws_sns_topic" "cf_4xx_alarm" {
  provider = aws.us_east_1 // Angabe des Providers für die SNS-Topics, damit die CloudWatch Alarme die SNS-Topics in der Region us-east-1 erreichen können, da CloudWatch Alarme nur SNS-Topics in der Region us-east-1 als Alarmaktionen unterstützen
  name = var.alarm_name_4xx 
}

resource "aws_sns_topic" "cf_5xx_alarm" {
  provider = aws.us_east_1
  name = var.alarm_name_5xx
}

resource "aws_sns_topic" "requests_alarm" {
  provider = aws.us_east_1
  name = var.alarm_name_requests
}
