# You must complete the following scenerio.

# A European gaming company is moving to GCP.  It has the following requirements in it's first stage migration to the Cloud:

# A) You must choose a region in Europe to host it's prototype gaming information.  This page must only be on a RFC 1918 Private 10 net and can't be accessible from the Internet.
# B) The Americas must have 2 regions and both must be RFC 1918 172.16 based subnets.  They can peer with HQ in order to view the homepage however, they can only view the page on port 80.
# C) Asia Pacific region must be choosen and it must be a RFC 1918 192.168 based subnet.  This subnet can only VPN into HQ.  Additionally, only port 3389 is open to Asia. No 80, no 22.

# Deliverables.
# 1) Complete Terraform for the entire solution.
# 2) Git Push of the solution to your GitHub.
# 3) Screenshots showing how the HQ homepage was accessed from both the Americas and Asia Pacific. 


# Firewall Rule to Allow HTTP, SSH and ICMP Traffic
resource "google_compute_firewall" "eu-firewall" {
  name    = var.eu-vpc.vpc.firewall
  network = google_compute_network.eu-vpc.self_link

  allow {
    protocol = "tcp"
    #ports    = ["22", "80", "3389"]
    ports = var.ports
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  priority      = 1000
  target_tags   = ["http-server", "iap-ssh-allowed"]
}

# Create an Instance in Europe
resource "google_compute_instance" "eu-instance" {
  name         = var.eu-vpc.eu-subnet.instance-name
  machine_type = var.machine_types.linux.machine_type
  zone         = var.eu-vpc.eu-subnet.zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240617"
      size  = 10
      type  = "pd-balanced"
    }
    auto_delete = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.eu-subnet.name

    access_config {
      #   network_tier = "PREMIUM"
    }
  }

  tags = ["http-server"]

  metadata = {
    startup-script = file("startup.sh")
  }

  depends_on = [
    google_compute_network.eu-vpc,
    google_compute_subnetwork.eu-subnet,
    google_compute_firewall.eu-firewall
  ]
}

# create a europe vpc network
resource "google_compute_network" "eu-vpc" {
  name                    = "eu-vpc"
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


# Peering from US to EU
# resource "google_compute_network_peering" "us-to-eu" {
#   name         = "us-to-eu-peering"
#   network      = google_compute_network.us-vpc.id
#   peer_network = google_compute_network.eu-vpc.id
# }

# Peering from EU to US
# resource "google_compute_network_peering" "eu-to-us" {
#   name         = "eu-to-us-peering"
#   network      = google_compute_network.eu-vpc.id
#   peer_network = google_compute_network.us-vpc.id
# }

# Peering from US West to EU
# resource "google_compute_network_peering" "uswest-to-eu" {
#   name         = "uswest-to-eu-peering"
#   network      = google_compute_network.uswest-vpc.id
#   peer_network = google_compute_network.eu-vpc.id
# }

# Peering from EU to US West
# resource "google_compute_network_peering" "eu-to-uswest" {
#   name         = "eu-to-uswest-peering"
#   network      = google_compute_network.eu-vpc.id
#   peer_network = google_compute_network.uswest-vpc.id
# }

# resource "google_compute_vpn_gateway" "eu-vpn-gw" {
#   name    = "eu-vpn-gateway"
#   network = google_compute_network.eu-vpc.id
#   region  = var.eu-vpc.eu-subnet.region
# }

# Main-EU.tf

# Create a Europe VPC network
# resource "google_compute_network" "eu-vpc" {
#   name                    = "eu-vpc"
#   auto_create_subnetworks = false
# }

# Create a Europe subnet
# resource "google_compute_subnetwork" "eu-subnet" {
#   name                     = var.eu-vpc.eu-subnet.name
#   ip_cidr_range            = var.eu-vpc.eu-subnet.cidr
#   region                   = var.eu-vpc.eu-subnet.region
#   network                  = google_compute_network.eu-vpc.id
#   private_ip_google_access = true
# }

# Create a firewall to allow HTTP traffic in Europe
# resource "google_compute_firewall" "eu-firewall" {
#   name    = var.eu-vpc.vpc.firewall
#   network = google_compute_network.eu-vpc.self_link

#   allow {
#     protocol = "tcp"
#     ports    = ["22", "80", "3389"]
#   }

#   allow {
#     protocol = "icmp"
#   }

#   source_ranges = ["0.0.0.0/0"]
#   priority      = 1000
#   target_tags   = ["http-server", "iap-ssh-allowed"]
# }

# VPN Gateway in Europe
# resource "google_compute_vpn_gateway" "eu-vpn-gw" {
#   name    = "eu-vpn-gateway"
#   network = google_compute_network.eu-vpc.id
#   region  = var.eu-vpc.eu-subnet.region
# }

# Peering configurations
# resource "google_compute_network_peering" "us-to-eu" {
#   name         = "us-to-eu-peering"
#   network      = google_compute_network.us-vpc.id
#   peer_network = google_compute_network.eu-vpc.id
# }

# resource "google_compute_network_peering" "eu-to-us" {
#   name         = "eu-to-us-peering"
#   network      = google_compute_network.eu-vpc.id
#   peer_network = google_compute_network.us-vpc.id
# }

# resource "google_compute_network_peering" "uswest-to-eu" {
#   name         = "uswest-to-eu-peering"
#   network      = google_compute_network.uswest-vpc.id
#   peer_network = google_compute_network.eu-vpc.id
# }

# resource "google_compute_network_peering" "eu-to-uswest" {
#   name         = "eu-to-uswest-peering"
#   network      = google_compute_network.eu-vpc.id
#   peer_network = google_compute_network.uswest-vpc.id
# }
