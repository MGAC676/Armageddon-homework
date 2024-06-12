
output "bucket_url" {
  value = "${var.google_bucket_url}${google_storage_bucket.armageddon-11.name}/index4.html"
}
