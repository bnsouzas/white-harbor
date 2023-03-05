resource "google_cloud_run_service" "white-harbor" {
  name     = "${var.app}"
  location = var.region
  
  metadata {
    labels = {
        app = var.app
    }
  }

  template {
    metadata {
      labels = {
          app = var.app
      }
      annotations = merge({
        "autoscaling.knative.dev/maxScale" = 5
        "autoscaling.knative.dev/minScale" = 0
      })
    } 
    spec {
      containers {
        image = "devopsfaith/krakend:2.1"
        volume_mounts {
            name = "krakend-config"
            mount_path = "/etc/krakend/"
        }
        resources {
          limits = {
            cpu = "1000m"
            memory = "256Mi"
          }
        }
      }
      volumes {
        name = "krakend-config"
        secret {
            secret_name = google_secret_manager_secret.krakend-config.secret_id
            default_mode = "0444"
            items {
                key = google_secret_manager_secret_version.krakend-cofig-version.version
                path = "krakend.json"
            }
        }
    }
    }
  }

  depends_on   = [
      google_secret_manager_secret_version.krakend-cofig-version
  ]
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.white-harbor.location
  project     = google_cloud_run_service.white-harbor.project
  service     = google_cloud_run_service.white-harbor.name

  policy_data = data.google_iam_policy.noauth.policy_data

  depends_on   = [
    google_cloud_run_service.white-harbor
  ]
}