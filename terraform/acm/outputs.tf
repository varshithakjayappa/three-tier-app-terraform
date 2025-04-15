# export the acm certificate arn
output "certificate_arn" {
  value = aws_acm_certificate.acm_certificate.arn
}

# export the domain name
output "domain_name" {
  value = var.domain_name
}

output "record_names" {
  value = [
    for domain, record in aws_route53_record.route53_record :
    "${domain} => ${record.name}"
  ]
}
