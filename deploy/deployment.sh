#!/bin/bash

cd /home/ec2-user/deploy || { echo "Failed to change directory to /home/ec2-user/deploy"; exit 1; }

sudo yum update -y
sudo yum install -y amazon-linux-extras
sudo amazon-linux-extras install docker -y
sudo systemctl start docker
sudo systemctl enable docker

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

if [ -f /usr/local/bin/docker-compose ]; then
    echo "Docker Compose installed successfully."
else
    echo "Failed to install Docker Compose."
    exit 1
fi

sudo mkdir -p /etc/letsencrypt
sudo chown -R $USER:$USER /etc/letsencrypt

sudo /usr/local/bin/docker-compose -f docker-compose-initiate.yaml up -d nginx
sudo /usr/local/bin/docker-compose -f docker-compose-initiate.yaml run --rm certbot certonly --webroot --webroot-path=/usr/share/nginx/html -m harmonyltd@outlook.es --agree-tos --non-interactive -d harmony-prub.duckdns.org
sudo /usr/local/bin/docker-compose -f docker-compose-initiate.yaml down

sudo /usr/local/bin/docker-compose -f docker-compose.yaml up -d