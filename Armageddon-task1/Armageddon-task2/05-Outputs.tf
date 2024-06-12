output "public_ip" {
  value = google_compute_instance.armageddon2.network_interface[0].access_config[0].nat_ip
}

output "vpc" {
  value = google_compute_network.armageddon2_vpc.name
}

output "subnet" {
  value = google_compute_subnetwork.armageddon2_subnet.name
}

output "internal_ip" {
  value = google_compute_instance.armageddon2.network_interface[0].network_ip
}


































# output "public_ip" {
#   value = google_compute_instance.armageddon2-instance.network_interface[0].access_config[0].nat_ip
# }
# output "bucket_url" {
#   value = "${var.google_bucket_url}${google_storage_bucket.vanguard64.name}/startup.sh"
# }

# output "vpc_id" {
#   value = google_compute_network.armageddon2_vpc.id
# }

# output "subnet_id" {
#   value = google_compute_subnetwork.armageddon2_subnet.id
# }

# output "internal_ip" {
#   value = google_compute_instance.armageddon2-instance.network_interface.0.network_ip

# }







# output "instance_ip" {
#   value = google_compute_instance.vanguard64_instance.network_interface.0.access_config.0.assigned_nat_ip
# }

# output "instance_name" {
#   value = google_compute_instance.vanguard64_instance.name
# }







