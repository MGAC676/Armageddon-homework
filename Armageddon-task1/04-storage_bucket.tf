resource "google_storage_bucket_object" "picture" {
  name   = "index4.html"
  source = "index4.html"
  bucket = google_storage_bucket.armageddon-11.name
}

resource "google_storage_bucket_object" "statec_site_src" {
  name   = "index4.html"
  source = "index4.html"
  bucket = google_storage_bucket.armageddon-11.name
}
