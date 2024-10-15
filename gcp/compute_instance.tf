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
    # hostname     = "rh-staging-master"
    
    boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"  # boot image ubuntu 24.04 lts
      size = 20
      }
    }
    # scratch_disk {
    # interface = "NVME"
    #  }
     network_interface {
        network       = "default"   # Replace with your VPC network
        access_config {}            # Allows external (public) IP access
    }
   #  metadata_startup_script = file("entry-script.sh")
     
     metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
     }
    connection {
      type        = "ssh"
      user        = "ubuntu"                     # Use the 'ubuntu' user for connection
      private_key = file("~/.ssh/id_rsa")        # Path to your private key
      host        = google_compute_instance.rh-staging.network_interface[0].access_config[0].nat_ip  # Get the VM public IP
    }
     provisioner "remote-exec" {
    
    # Use the entry-script.sh file for inline execution
    script = file("entry-script.sh")  # Read the script from the current module path
    # #OR
    #  inline = [
    #   "sudo apt-get update",
    #   "sudo apt-get install -y apache2"
    # ]
  }
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






