# resource "google_service_account" "default" {
#      # The unique ID for the service account
#   account_id = "2520f7d965511976b9e442b2560731371fa79cb2" 
#   display_name = "SA-vm"
# }
resource "google_compute_instance" "rh-staging" {
    name = "rh-stage-master"
    machine_type = "e2-medium"
    zone = "us-central1-a"
    tags = ["foo", "bar"] #network tag
    
    boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"  # Choose the boot image
      size = 23
      }
    }
    # scratch_disk {
    # interface = "NVME"
    #  }
     network_interface {
        network       = "default"   # Replace with your VPC network
        access_config {}            # Allows external (public) IP access
    }
     metadata_startup_script = file("entry-script.sh")
    #  metadata_startup_script = <<-EOT
    #     #!/bin/bash
    #     sudo apt-get update
    #     sudo apt-get install -y apache2
    #  EOT
}

#     service_account {
#     email  = google_service_account.default.email
#     scopes = ["cloud-platform"]  # Define the scopes the VM has access to
#   }






