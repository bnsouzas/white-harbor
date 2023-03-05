resource "google_dns_record_set" "white-harbor-dns" {
  name         = "api.buddycash.app."
  managed_zone = "buddycash-app"
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_forwarding_rule.white-harbor-frontend-ssl.ip_address]
  depends_on = [
    google_compute_global_forwarding_rule.white-harbor-frontend-ssl
  ]
}

resource "google_dns_record_set" "master-of-coin-dns" {
  name         = "buddycash.app."
  managed_zone = "buddycash-app"
  type         = "A"
  ttl          = 300

  rrdatas = [module.master-of-coin.ip_address]

  depends_on = [
    module.master-of-coin
  ]
}

