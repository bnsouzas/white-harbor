resource "google_compute_region_network_endpoint_group" "white-harbor-neg" {
  name                  = "${var.app}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = google_cloud_run_service.white-harbor.name
  }
}

resource "google_compute_backend_service" "white-harbor-backend-service" {
  name = "${var.app}"
  protocol = "HTTPS"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  backend {
    group = google_compute_region_network_endpoint_group.white-harbor-neg.id
  }
  depends_on = [
    google_compute_region_network_endpoint_group.white-harbor-neg
  ]
}

resource "google_compute_url_map" "white-harbor-url-map" {
  name = "${var.app}"
  default_service = google_compute_backend_service.white-harbor-backend-service.self_link
  depends_on = [
     google_compute_backend_service.white-harbor-backend-service
  ]
}

# resource "google_compute_target_http_proxy" "white-harbor-proxy" {
#   name = "${var.app}-proxy"
#   url_map = google_compute_url_map.white-harbor-url-map.self_link
#   depends_on = [
#      google_compute_url_map.white-harbor-url-map
#   ]
# }

resource "google_compute_target_https_proxy" "white-harbor-proxy-ssl" {
  name = "${var.app}-proxy-ssl"
  url_map = google_compute_url_map.white-harbor-url-map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.buddycash.id]
  depends_on = [
     google_compute_url_map.white-harbor-url-map,
     google_compute_managed_ssl_certificate.buddycash
  ]
}

# resource "google_compute_global_forwarding_rule" "white-harbor-frontend" {
#   name = "${var.app}"
#   port_range = "80"
#   load_balancing_scheme = "EXTERNAL_MANAGED"
#   target = google_compute_target_http_proxy.white-harbor-proxy.id
#   depends_on = [
#      google_compute_target_http_proxy.white-harbor-proxy
#   ]
# }

resource "google_compute_global_forwarding_rule" "white-harbor-frontend-ssl" {
  name = "${var.app}-ssl"
  port_range = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target = google_compute_target_https_proxy.white-harbor-proxy-ssl.id
  depends_on = [
     google_compute_target_https_proxy.white-harbor-proxy-ssl
  ]
}