terraform {
  required_providers { // AWS Provider
    aws = {
      source  = "hashicorp/aws" // offizielle Quelle des AWS Providers
      version = "~> 5.0"        // AWS Provider Version, erlaubt alle Versionen ab 5.0, aber keine 6.0 oder höher (stabilitätsgarantie innerhalb der 5.x Versionen)
    }
  }
}

provider "aws" {          // AWS Provider Konfiguration
  region = "eu-central-1" // AWS Region DEU (Frankfurt)
}

provider "aws" { // angelegt, für die SNS-Topics, damit die CloudWatch Alarme die SNS-Topics in der Region us-east-1 erreichen können, da CloudWatch Alarme nur SNS-Topics in der Region us-east-1 als Alarmaktionen unterstützen
  alias = "us_east_1" // Alias für diesen Provider, damit er in den Ressourcen referenziert werden kann
  region = "us-east-1"
}