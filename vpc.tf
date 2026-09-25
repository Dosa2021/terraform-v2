# VPC（Virtual Private Cloud）
# AWSアカウント内の仮想ネットワーク空間
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"                                 # IPアドレスの範囲（65,536個のIPアドレス）
  enable_dns_hostnames = true                                          # DNSホスト名を有効化
  enable_dns_support   = true                                          # DNS解決を有効化
  tags                 = { Name = "${var.environment}-terraform-vpc" } # 管理用のタグ（名前）
}

# パブリックサブネット
# VPC内の一部領域で、インターネットからアクセス可能なネットワーク
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id      # 上で作成したVPCのIDを参照
  cidr_block              = "10.0.1.0/24"        # 256個のIPアドレス
  availability_zone       = "${var.aws_region}a" # アベイラビリティゾーン（物理的なデータセンター）
  map_public_ip_on_launch = true                 # インスタンス起動時に自動でパブリックIP割り当て
  tags                    = { Name = "terraform-public-subnet" }
}
resource "aws_subnet" "public-c" {
  vpc_id                  = aws_vpc.main.id      # 上で作成したVPCのIDを参照
  cidr_block              = "10.0.2.0/24"        # 256個のIPアドレス
  availability_zone       = "${var.aws_region}c" # アベイラビリティゾーン（物理的なデータセンター）
  map_public_ip_on_launch = true                 # インスタンス起動時に自動でパブリックIP割り当て
  tags                    = { Name = "terraform-public-subnet-c" }
}

# インターネットゲートウェイ
# VPCとインターネットを接続するゲート
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "terraform-igw" }
}

# ルートテーブル
# ネットワークトラフィックの経路を定義
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"                  # すべての宛先（インターネット全体）
    gateway_id = aws_internet_gateway.main.id # インターネットゲートウェイ経由で通信
  }

  tags = { Name = "terraform-public-rt" }
}

# ルートテーブルとサブネットの関連付け
# サブネットにルートテーブルを適用
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-c" {
  subnet_id      = aws_subnet.public-c.id
  route_table_id = aws_route_table.public.id
}

# セキュリティグループ
# ファイアウォールのルール定義（どのポートからの通信を許可するか）
resource "aws_security_group" "web" {
  name        = "${var.environment}-terraform-web-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  # インバウンドルール（外部からの通信）：HTTP
  ingress {
    from_port = 80    # 開始ポート
    to_port   = 80    # 終了ポート
    protocol  = "tcp" # プロトコル
    # cidr_blocks = ["0.0.0.0/0"] # すべてのIPアドレスから許可
    security_groups = [aws_security_group.elb.id]
    description     = "Allow HTTP"
  }

  # ALB → Nuxt (docker compose)
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.elb.id]
    description     = "Nuxt from ALB"
  }

  # インバウンドルール：SSH（サーバーにリモート接続するため）
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 本番環境では自社IPのみに制限推奨
    description = "Allow SSH"
  }

  # アウトバウンドルール（サーバーから外部への通信）
  egress {
    from_port   = 0 # すべてのポート
    to_port     = 0
    protocol    = "-1"          # すべてのプロトコル
    cidr_blocks = ["0.0.0.0/0"] # すべての宛先へ許可
  }

  tags = { Name = "${var.environment}-terraform-web-sg" }
}

# CloudFront から ALB への通信のみ許可するためのマネージドプレフィックスリスト
data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group" "elb" {
  name        = "${var.environment}-terraform-elb-sg"
  description = "Security group for elb"
  vpc_id      = aws_vpc.main.id

  # CF オリジン http-only 用（応急）。本番では CloudFront プレフィックスリスト等に戻す
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP for CloudFront origin (temporary http-only)"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS (temporary open for debugging)"
  }


  # アウトバウンドルール（サーバーから外部への通信）
  egress {
    from_port   = 0 # すべてのポート
    to_port     = 0
    protocol    = "-1"          # すべてのプロトコル
    cidr_blocks = ["0.0.0.0/0"] # すべての宛先へ許可
  }

  tags = { Name = "${var.environment}-terraform-elb-sg" }
}
