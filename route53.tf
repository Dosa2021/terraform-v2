# TODO: 要修正
resource "aws_route53_record" "test" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.test.domain_name
    zone_id                = aws_cloudfront_distribution.test.hosted_zone_id
    evaluate_target_health = false
  }
}
