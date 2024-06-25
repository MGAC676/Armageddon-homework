# create asia vpc network
resource "google_compute_network" "asia-vpc" {
  name                    = var.asia-vpc.vpc.name
  auto_create_subnetworks = false
}

# create an asia subnet
resource "google_compute_subnetwork" "asia-subnet" {
  name                     = var.asia-vpc.asia-subnet.name
  ip_cidr_range            = var.asia-vpc.asia-subnet.cidr
  region                   = var.asia-vpc.asia-subnet.region
  network                  = google_compute_network.asia-vpc.id
  private_ip_google_access = true
}

# create a firewall for asia RDP
resource "google_compute_firewall" "asia-allow-rdp" {
  project = var.project_id
  name    = var.asia-vpc.vpc.firewall
  network = google_compute_network.asia-vpc.id

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  # direction = "EGRESS"

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["asia-rdp-server"]

}
# create an asia instance windows machine
resource "google_compute_instance" "asia-instance" {
  name         = "${var.asia-vpc.asia-subnet.instance-name}taiwan"
  machine_type = var.machine_types.windows.machine_type
  zone         = var.asia-vpc.asia-subnet.zone

  boot_disk {
    auto_delete = true
    device_name = "asia-instance"

    initialize_params {
      image = "projects/windows-cloud/global/images/windows-server-2022-dc-v20240415"
      size  = 60
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = true
  deletion_protection = false
  enable_display      = true

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  network_interface {
    access_config {

      network_tier = "STANDARD"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/red-pill-production94/regions/asia-southeast1/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "340761840392-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["asia-rdp-server"]

}
