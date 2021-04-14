resource "aws_route53_zone" "web-domain" {
  name = "plan-ore.co.uk"
  #private_zone = false

}

resource "aws_route53_record" "web-record" {
  zone_id = aws_route53_zone.web-domain.zone_id
  name    = aws_route53_zone.web-domain.name
  type    = "A"

  alias {
    name                   = aws_elb.web-elb.dns_name
    zone_id                = aws_elb.web-elb.zone_id
    evaluate_target_health = false
  }
}