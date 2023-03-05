output "ip_address" {
  description = "Load balancer frontend ip address"
  value       = google_compute_global_forwarding_rule.master-of-coin-frontend-ssl.ip_address
}