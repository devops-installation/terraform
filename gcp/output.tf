output "public_ip" {
    value = google_compute_instance.rh-staging-master.network_interface[0].access_config[0].nat_ip
}