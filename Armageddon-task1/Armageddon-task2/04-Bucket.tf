# resource "google_storage_bucket_object" "picture" {
#   name   = "index4.html"
#   source = "index4.html"
#   bucket = google_storage_bucket.armageddon-11.name
# }

# resource "google_storage_bucket_object" "statec_site_src" {
#   name   = "index4.html"
#   source = "index4.html"
#   bucket = google_storage_bucket.armageddon-11.name
# }

resource "google_storage_bucket" "armageddon2" {
  name          = "${var.project_id}-armageddon2"
  location      = var.location
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

# resource "google_storage_bucket_access_control" "public_rule" {
#   bucket = google_storage_bucket.armageddon-11.name
#   role   = "READER"
#   entity = "allUsers"
# }

# resource "google_storage_bucket_iam_binding" "public_access" {
#   bucket = google_storage_bucket.armageddon-11.name
#   role   = "roles/storage.objectViewer"
#   members = [
#     "allUsers",
#   ]
# }

# resource "google_storage_bucket_object" "default" {
#   name         = "startup.sh"
#   source       = "scripts/startup.sh" # Path to the local HTML file
#   content_type = "text/x-shellscript"
#   bucket       = google_storage_bucket.armageddon2.id
# }
