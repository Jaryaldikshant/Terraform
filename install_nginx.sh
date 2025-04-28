#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1>Hi, DevOps</h1><h3>Learning Terraform ..</h3>" | sudo tee /var/www/html/index.html