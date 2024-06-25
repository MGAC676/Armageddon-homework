# create a europe vpc network
resource "google_compute_network" "eu-vpc" {
  name                    = var.eu-vpc.vpc.name
  auto_create_subnetworks = false
}

# create a eu subnet
resource "google_compute_subnetwork" "eu-subnet" {
  name                     = var.eu-vpc.eu-subnet.name
  ip_cidr_range            = var.eu-vpc.eu-subnet.cidr
  region                   = var.eu-vpc.eu-subnet.region
  network                  = google_compute_network.eu-vpc.id
  private_ip_google_access = true
}


resource "google_compute_firewall" "eu-firewall" {
  name    = var.eu-vpc.vpc.firewall
  network = google_compute_network.eu-vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  allow {
    protocol = "icmp"
  }

  # direction = "INGRESS"

  target_tags   = ["http-server"]
  source_ranges = ["0.0.0.0/0"]

  priority = 1000
}




resource "google_compute_instance" "eu-instance" {
  name         = var.eu-vpc.eu-subnet.instance-name
  machine_type = var.machine_types.linux.machine_type
  zone         = var.eu-vpc.eu-subnet.zone


  boot_disk {
    auto_delete = true
    device_name = "eu-instance"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240617"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }


  metadata = {
    startup-script = "#Thanks to Remo\n#!/bin/bash\n# Update and install Apache2\napt update\napt install -y apache2\n\n# Start and enable Apache2\nsystemctl start apache2\nsystemctl enable apache2\n\n# GCP Metadata server base URL and header\nMETADATA_URL=\"http://metadata.google.internal/computeMetadata/v1\"\nMETADATA_FLAVOR_HEADER=\"Metadata-Flavor: Google\"\n\n# Use curl to fetch instance metadata\nlocal_ipv4=$(curl -H \"$${METADATA_FLAVOR_HEADER}\" -s \"$${METADATA_URL}/instance/network-interfaces/0/ip\")\nzone=$(curl -H \"$${METADATA_FLAVOR_HEADER}\" -s \"$${METADATA_URL}/instance/zone\")\nproject_id=$(curl -H \"$${METADATA_FLAVOR_HEADER}\" -s \"$${METADATA_URL}/project/project-id\")\nnetwork_tags=$(curl -H \"$${METADATA_FLAVOR_HEADER}\" -s \"$${METADATA_URL}/instance/tags\")\n\n# Create a simple HTML page and include instance details\ncat <<EOF > /var/www/html/index.html\n<html><body>\n<h2>This Was Truly Challenging My Brain Thank You Theo</h2>\n<h2>Together We Inspire Together We Achieve, Stand As One Brothers</h2>\n<h3>If You Are Trying To Complete This Assignment By Yourself, You Are Crazy!</h3>\n<iframe src=\"https://giphy.com/embed/fWAlpoPgxSF47aqh8R\" width=\"1000\" height=\"400\" frameBorder=\"0\" class=\"giphy-embed\" allowFullScreen></iframe><p><a href=\"https://giphy.com/gifs/TOEIAnimationUK-goku-dragon-ball-son-fWAlpoPgxSF47aqh8R\">via GIPHY</a></p>\n<p><b>Instance Name:</b> $(hostname -f)</p>\n<p><b>Instance Private IP Address: </b> $local_ipv4</p>\n<p><b>Zone: </b> $zone</p>\n<p><b>Project ID:</b> $project_id</p>\n<p><b>Network Tags:</b> $network_tags</p>\n</body></html>\nEOF"
  }


  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/red-pill-production94/regions/europe-west1/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "juggernaut-97@red-pill-production94.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server"]

}

