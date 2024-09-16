# #!/bin/bash
# sudo apt update
# sudo apt install -y nginx
# sudo systemctl start nginx
# sudo systemctl enable nginx
#!/bin/bash

# Update package index
sudo apt update

# Install Docker
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose (optional)
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Pull Nginx Docker image
sudo docker pull nginx:latest

# Run Nginx container
sudo docker run -d --name nginx -p 80:80 nginx