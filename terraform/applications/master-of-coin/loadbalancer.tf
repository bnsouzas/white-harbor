resource "google_compute_region_network_endpoint_group" "master-of-coin-neg" {
  name                  = "${var.app}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.cloudrun_service_name
  }
}

resource "google_compute_backend_service" "master-of-coin-backend" {
  name = "${var.app}"
  protocol = "HTTPS"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  enable_cdn = true
  cdn_policy {
    cache_mode = "CACHE_ALL_STATIC"
    default_ttl = 86400
    client_ttl = 129600
    max_ttl = 172800
    cache_key_policy {
      include_host = true
      include_protocol = true
      include_query_string = true
    }
  }

  backend {
    group = google_compute_region_network_endpoint_group.master-of-coin-neg.id
  }
  depends_on = [
      google_compute_region_network_endpoint_group.master-of-coin-neg
  ]
}

resource "google_compute_url_map" "master-of-coin-url-map" {
  name = "${var.app}"
  default_service = google_compute_backend_service.master-of-coin-backend.self_link
  depends_on = [
     google_compute_backend_service.master-of-coin-backend
  ]
}

# resource "google_compute_target_http_proxy" "master-of-coin-proxy" {
#   name = "${var.app}-proxy"
#   url_map = google_compute_url_map.master-of-coin-url-map.self_link
#   depends_on = [
#      google_compute_url_map.master-of-coin-url-map
#   ]
# }

resource "google_compute_target_https_proxy" "master-of-coin-proxy-ssl" {
  name = "${var.app}-proxy-ssl"
  url_map = google_compute_url_map.master-of-coin-url-map.self_link
  ssl_certificates = [var.certificate.id]
  depends_on = [
     google_compute_url_map.master-of-coin-url-map,
     var.certificate
  ]
}

# resource "google_compute_global_forwarding_rule" "master-of-coin-frontend" {
#   name = "${var.app}"
#   port_range = "80"
#   load_balancing_scheme = "EXTERNAL_MANAGED"
#   target = google_compute_target_http_proxy.master-of-coin-proxy.id
#   depends_on = [
#      google_compute_target_http_proxy.master-of-coin-proxy
#   ]
# }

resource "google_compute_global_forwarding_rule" "master-of-coin-frontend-ssl" {
  name = "${var.app}-ssl"
  port_range = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target = google_compute_target_https_proxy.master-of-coin-proxy-ssl.id
  depends_on = [
     google_compute_target_https_proxy.master-of-coin-proxy-ssl
  ]
}