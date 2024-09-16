# #!/bin/bash
# sudo apt update
# sudo apt install -y nginx
# sudo systemctl start nginx
# sudo systemctl enable nginx
#!/bin/bash

# Update the package index
sudo apt update

# Install Docker dependencies
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add the Docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'

# Update the package index again
sudo apt update

# Install Docker
sudo apt install -y docker-ce

# Start Docker
sudo systemctl start docker

# Enable Docker to start at boot
sudo systemctl enable docker
sudo docker run -d --name nginx -p 80:80 nginx