output "public_ip_master" {
    value = google_compute_instance.rh-staging-master.network_interface[0].access_config[0].nat_ip
}
output "public_ip_node" {
    value = google_compute_instance.rh-staging-node.network_interface[0].access_config[0].nat_ip

}