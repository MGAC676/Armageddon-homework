# Create a publically accesible bucket in GCP with Terraform.  You must complete the following tasks.
# 1) Terraform script
# 2) Git Push the script to your Github
# 3) Outpub file must show the public link
# 4) Must have an index.html file within

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.27.0"
    }
  }
}

provider "google" {
  # Configuration options
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = var.credentials
}


resource "google_storage_bucket" "armageddon-11" {
  name          = "${var.project_id}-armageddon-11"
  location      = var.location
  force_destroy = true

  website {
    main_page_suffix = "index4.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.armageddon-11.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_iam_binding" "public_access" {
  bucket = google_storage_bucket.armageddon-11.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}

resource "google_storage_bucket_object" "index_html" {
  name         = "index4.html"
  source       = "index4.html" # Path to the local HTML file
  content_type = "text/html"
  bucket       = google_storage_bucket.armageddon-11.id
}

resource "google_storage_bucket_object" "image1" {
  name   = "happy-days.jpg" # Specify the path where the image should be stored in the bucket
  source = "happy-days.jpg" # Path to the local image file
  bucket = google_storage_bucket.armageddon-11.id
}

resource "google_storage_bucket_object" "image2" {
  name   = "copacabana-rio-de-janeiro.jpg" # Specify the path where the image should be stored in the bucket
  source = "copacabana-rio-de-janeiro.jpg" # Path to the local image file
  bucket = google_storage_bucket.armageddon-11.id
}

resource "google_storage_bucket_object" "image3" {
  name   = "carnival-rio3.jpg" # Specify the path where the image should be stored in the bucket
  source = "carnival-rio3.jpg" # Path to the local image file
  bucket = google_storage_bucket.armageddon-11.id
}

resource "google_storage_bucket_object" "image4" {
  name   = "brazil-carnaival-1.jpg" # Specify the path where the image should be stored in the bucket
  source = "brazil-carnaival-1.jpg" # Path to the local image file
  bucket = google_storage_bucket.armageddon-11.id
}



























