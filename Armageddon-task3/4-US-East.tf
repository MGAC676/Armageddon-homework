# create a us vpc network
resource "google_compute_network" "us-vpc" {
  name                    = var.us-vpc.vpc.name
  auto_create_subnetworks = false
}

# create an us-east subnet
resource "google_compute_subnetwork" "us-east-subnet" {
  name                     = var.us-vpc.us-east-subnet.name
  ip_cidr_range            = var.us-vpc.us-east-subnet.cidr
  region                   = var.us-vpc.us-east-subnet.region
  network                  = google_compute_network.us-vpc.id
  private_ip_google_access = true
}

# create a firewall to allow http from us to europe
resource "google_compute_firewall" "us-firewall" {
  name    = var.us-vpc.vpc.firewall
  network = google_compute_network.us-vpc.id

  allow {
    protocol = "tcp"
    ports    = var.ports
  }

  # direction = "EGRESS"

  target_tags   = ["us-http-server", "iap-ssh-allowed"]
  source_ranges = ["0.0.0.0/0"]
}

# create a us-east instance
resource "google_compute_instance" "us-east-instance" {
  depends_on = [google_compute_network.us-vpc, google_compute_subnetwork.us-east-subnet]

  name         = var.us-vpc.us-east-subnet.instance-name
  machine_type = var.machine_types.linux.machine_type
  zone         = var.us-vpc.us-east-subnet.zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240617"
      size  = 10
      type  = "pd-balanced"
    }
    auto_delete = true
    mode        = "READ_WRITE"
  }


  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false


  network_interface {



    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/red-pill-production94/regions/us-east1/subnetworks/default"
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



