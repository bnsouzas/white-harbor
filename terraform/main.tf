provider "google" {
  project     = var.project_id
  region      = var.region
}

module "master-of-coin" {
  source  = "./applications/master-of-coin"
  app = "master-of-coin"
  region = var.region
  cloudrun_service_name = "master-of-coin"
  certificate = google_compute_managed_ssl_certificate.buddycash
}