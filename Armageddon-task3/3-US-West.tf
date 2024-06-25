# create a us west vpc network
resource "google_compute_network" "us-west-vpc" {
  name                    = var.us-west-vpc.vpc.name
  auto_create_subnetworks = false
  project                 = var.project_id
}

# create an us-west subnet
resource "google_compute_subnetwork" "us-west-subnet" {
  name                     = var.us-west-vpc.us-west-subnet.name
  ip_cidr_range            = var.us-west-vpc.us-west-subnet.cidr
  region                   = var.us-west-vpc.us-west-subnet.region
  network                  = google_compute_network.us-west-vpc.id
  project                  = var.project_id
  private_ip_google_access = true
}


# Firewall rule to allow HTTP and SSH
resource "google_compute_firewall" "us-west-firewall" {
  name    = var.us-west-vpc.vpc.firewall
  network = google_compute_network.us-west-vpc.self_link

  allow {
    protocol = "tcp"
    ports    = var.ports
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_instance" "us-west-instance" {
  name         = var.us-west-vpc.us-west-subnet.instance-name
  machine_type = var.machine_types.linux.machine_type
  zone         = var.us-west-vpc.us-west-subnet.zone


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
    subnetwork  = "projects/red-pill-production94/regions/us-west1/subnetworks/default"
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



