resource "google_compute_firewall" "default" {
    name    = "rh-firewall"
    network = "default"
    allow {
        protocol = "tcp"
        ports    = ["80", "443", "8080", "22"]
    }
    allow {
        protocol = "all"

    }
    allow {
      protocol = "icmp"
    }
    source_ranges = ["0.0.0.0/0"]
    source_tags = ["foo", "bar"]
    target_tags = ["bar", "foo"]
  
}