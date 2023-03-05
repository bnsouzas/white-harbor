resource "google_compute_managed_ssl_certificate" "buddycash" {
  name = "buddycash"

  managed {
    domains = ["buddycash.app.", "api.buddycash.app."]
  }
}