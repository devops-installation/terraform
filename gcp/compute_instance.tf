# resource "google_service_account" "default" {
#      # The unique ID for the service account
#   account_id = "2520f7d965511976b9e442b2560731371fa79cb2" 
#   display_name = "SA-vm"
# }
resource "google_compute_instance" "RH-staging" {
    name = "Rh-staging"
    machine_type = "e2-medium"
    zone = "us-central1-a"
    tags = ["foo", "bar"]
    boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"  # Choose the boot image
      }
    }
    scratch_disk {
    interface = "NVME"
     }
     network_interface {
        network       = "default"   # Replace with your VPC network
        access_config {}            # Allows external (public) IP access
    }
#     service_account {
#     email  = google_service_account.default.email
#     scopes = ["cloud-platform"]  # Define the scopes the VM has access to
#   }
}





