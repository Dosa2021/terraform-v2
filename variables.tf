variable "environment" {
  description = "environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"     # 変数の説明
  type        = string           # データ型（文字列）
  default     = "ap-northeast-1" # デフォルト値（東京リージョン）
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0794a632d5c1058bf" # Amazon Linux 2023（東京リージョン用）
}

variable "access_key" {
  description = "access_key"
  type        = string
  default     = ""
}

variable "secret_key" {
  description = "secret_key"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "instance_type"
  type        = string
  default     = "t3.micro"
}
