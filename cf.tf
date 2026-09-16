data "aws_acm_certificate" "cloudfront" {
  provider    = aws.us_east_1
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_cloudfront_distribution" "test" {
  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2"
  price_class         = "PriceClass_All"
  aliases             = ["test.dosaken.org"]
  default_root_object = ""
  #   TODO: waf
  #   web_acl_id          = "arn:aws:wafv2:us-east-1:797964065122:global/webacl/CreatedByCloudFront-1f1d650c/2fff20b6-92ee-4fad-a5c9-b7a25229c223"

  tags = {
    Name = "${var.environment}-distribution"
  }

  # 現在の ALB オリジン
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = aws_lb.alb.dns_name

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_lb.alb.dns_name
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    cache_policy_id        = "83da9c7e-98b4-4e11-a168-04f0df8e2c65"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    # acm_certificate_arn      = "arn:aws:acm:us-east-1:797964065122:certificate/c182dd41-de46-469c-8da8-a6197b02c18d"
    acm_certificate_arn      = data.aws_acm_certificate.cloudfront.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
