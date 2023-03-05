data "local_file" "krakend-config-content" {
  filename = "../krakend/krakend.json"
}

resource "google_secret_manager_secret" "krakend-config" {
  secret_id = "krakend-config"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "krakend-cofig-version" {
  secret = google_secret_manager_secret.krakend-config.id
  secret_data = data.local_file.krakend-config-content.content
  depends_on   = [
      google_secret_manager_secret.krakend-config,
      data.local_file.krakend-config-content
  ]
}

resource "google_secret_manager_secret" "iron-bank-url" {
  secret_id = "iron-bank-url"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "iron-bank-url-version" {
  secret = google_secret_manager_secret.iron-bank-url.id
  secret_data = "https://api.buddycash.app/iron-bank/v1"
  depends_on   = [
      google_secret_manager_secret.iron-bank-url,
  ]
}

resource "google_secret_manager_secret" "project-region" {
  secret_id = "project-region"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "project-region-version" {
  secret = google_secret_manager_secret.project-region.id
  secret_data = var.region
  depends_on   = [
      google_secret_manager_secret.project-region,
  ]
}