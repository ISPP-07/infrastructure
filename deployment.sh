#!/bin/bash

# install and configure docker on the ec2 instance
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker

sudo docker build -t hello-world .

sudo docker run -dp 80:80 hello-world