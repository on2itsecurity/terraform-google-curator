# VPC Network
resource "google_compute_network" "this" {
  name                    = var.vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "this" {
  name                     = var.subnet_name
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.this.id
  ip_cidr_range            = var.subnet_range
  private_ip_google_access = true
}

# Firewall -- Allow Inbound
resource "google_compute_firewall" "allow_inbound" {
  name          = format("%s-%s", var.vm_name, "allow-inbound")
  project       = var.project_id
  network       = google_compute_network.this.id
  direction     = "INGRESS"
  priority      = 100
  source_ranges = distinct(concat(["185.46.232.0/22"], var.firewall_allow_ips))
  target_tags   = [var.vm_name]

  allow {
    protocol = "all"
  }
}

# Firewall -- Allow Outbound DNS
resource "google_compute_firewall" "allow_outbound_dns" {
  name               = format("%s-%s", var.vm_name, "allow-outbound-dns")
  project            = var.project_id
  network            = google_compute_network.this.id
  direction          = "EGRESS"
  priority           = 100
  destination_ranges = ["1.1.1.1/32", "8.8.8.8/32"]
  target_tags        = [var.vm_name]

  allow {
    protocol = "udp"
    ports    = ["53"]
  }
}

# Firewall -- Allow Outbound NTP
resource "google_compute_firewall" "allow_outbound_ntp" {
  name               = format("%s-%s", var.vm_name, "allow-outbound-ntp")
  project            = var.project_id
  network            = google_compute_network.this.id
  direction          = "EGRESS"
  priority           = 110
  destination_ranges = ["162.159.200.1/32", "162.159.200.123/32"]
  target_tags        = [var.vm_name]

  allow {
    protocol = "udp"
    ports    = ["123"]
  }
}

# Firewall -- Allow AUXO HTTPS
resource "google_compute_firewall" "allow_auxo_https" {
  name               = format("%s-%s", var.vm_name, "allow-auxo-https")
  project            = var.project_id
  network            = google_compute_network.this.id
  direction          = "EGRESS"
  priority           = 120
  destination_ranges = ["185.46.232.0/22"]
  target_tags        = [var.vm_name]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

# Firewall -- Allow AUXO NATS
resource "google_compute_firewall" "allow_auxo_nats" {
  name               = format("%s-%s", var.vm_name, "allow-auxo-nats")
  project            = var.project_id
  network            = google_compute_network.this.id
  direction          = "EGRESS"
  priority           = 130
  destination_ranges = ["185.46.232.0/22"]
  target_tags        = [var.vm_name]

  allow {
    protocol = "tcp"
    ports    = ["4222"]
  }
}

# Firewall -- Allow Google APIs (Private Google Access)
resource "google_compute_firewall" "allow_google_apis" {
  name               = format("%s-%s", var.vm_name, "allow-google-apis")
  project            = var.project_id
  network            = google_compute_network.this.id
  direction          = "EGRESS"
  priority           = 140
  destination_ranges = ["199.36.153.8/30", "199.36.153.4/30"]
  target_tags        = [var.vm_name]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

# DNS -- Route storage.googleapis.com via Private Google Access
resource "google_dns_managed_zone" "storage_googleapis" {
  count       = var.enable_outbound_storage ? 1 : 0
  name        = format("%s-%s", var.vm_name, "storage-googleapis")
  dns_name    = "storage.googleapis.com."
  project     = var.project_id
  description = "Route storage.googleapis.com via Private Google Access"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.this.id
    }
  }
}

resource "google_dns_record_set" "storage_googleapis" {
  count        = var.enable_outbound_storage ? 1 : 0
  name         = "storage.googleapis.com."
  managed_zone = google_dns_managed_zone.storage_googleapis[0].name
  project      = var.project_id
  type         = "A"
  ttl          = 300
  rrdatas      = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
}

# Firewall -- Deny All Outbound
resource "google_compute_firewall" "deny_all_outbound" {
  name               = format("%s-%s", var.vm_name, "deny-all-outbound")
  project            = var.project_id
  network            = google_compute_network.this.id
  direction          = "EGRESS"
  priority           = 65534
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = [var.vm_name]

  deny {
    protocol = "all"
  }
}

# Static External IP
resource "google_compute_address" "this" {
  name         = format("pip-%s", var.vm_name)
  project      = var.project_id
  region       = var.region
  address_type = "EXTERNAL"
  labels       = var.labels
}

# Curator VM
resource "google_compute_instance" "this" {
  name         = var.vm_name
  project      = var.project_id
  zone         = var.zone
  machine_type = var.machine_type
  tags         = [var.vm_name]

  boot_disk {
    initialize_params {
      image = "projects/on2it-public/global/images/family/curator-family"
      size  = var.disk_size_gb
      type  = var.disk_type
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.this.id
    network_ip = var.private_ip_address

    access_config {
      nat_ip = google_compute_address.this.address
    }
  }

  metadata = {
    authcode                 = var.auth_code
    google-logging-enable    = "0"
    google-monitoring-enable = "0"
  }

  service_account {
    email = "default"
    scopes = [
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
    ]
  }

  labels = var.labels
}
