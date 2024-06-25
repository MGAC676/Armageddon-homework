

project_id        = "put-your-project-id-here"
region            = "us-east1"
zone              = "us-east1-b"
credentials       = "red-pill-production94-credentials.json"
location          = "US"
google_bucket_url = "https://storage.googleapis.com/"
network_name      = "armageddon2-network"
subnet_name       = "armageddon2-subnet"
ip_cidr_range     = "10.197.0.0/24"
firewall_name     = "firewall-rule"
ports             = ["22", "80", "443"]
source_ranges     = ["0.0.0.0/0"]
machine_type      = "e2-medium"
instance_name     = "armageddon2-instance"
