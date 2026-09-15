# Terraformのバージョンとプロバイダの指定
# プロバイダ：AWS、GCPなどのクラウドサービスと通信するためのプラグイン
terraform {
  required_version = ">= 1.5.0"  # Terraform本体のバージョン指定
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # プロバイダの提供元
      version = "~> 5.0"         # プロバイダのバージョン（5.x系を使用）
    }
  }
}

# AWSプロバイダの設定
provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}