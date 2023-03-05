terraform {
  backend "gcs" {
    bucket  = "finance-assistent-tf-state"
    prefix  = "white-harbor"
  }
}