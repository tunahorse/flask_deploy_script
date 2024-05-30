#!/bin/bash

# Get the directory argument
APP_DIR=$1

# Update and install necessary packages
sudo apt update && sudo apt install -y python3 python3-venv nginx apt python3-pip

# Setup the virtual environment and activate it
python3 -m venv /root/flask_deploy_script/venv
source /root/flask_deploy_script/venv/bin/activate

# Install Flask and Gunicorn within the virtual environment
pip install Flask gunicorn

# Remove the default nginx configuration
sudo rm /etc/nginx/sites-enabled/default

# Create Gunicorn systemd service file
cat << EOF | sudo tee /etc/systemd/system/myflaskapp.service
[Unit]
Description=Gunicorn instance to serve Flask app
After=network.target
[Service]
User=root
Group=www-data
WorkingDirectory=/root/flask_deploy_script/$APP_DIR
ExecStart=/root/flask_deploy_script/venv/bin/gunicorn --workers 3 --bind unix:/root/flask_deploy_script/$APP_DIR/myflaskapp.sock -m 000 app:app
[Install]
WantedBy=multi-user.target
EOF

# Restart and enable the Gunicorn service
sudo systemctl daemon-reload
sudo systemctl restart myflaskapp
sudo systemctl enable myflaskapp

# Change permissions of the socket to be universally accessible, change this if you move to production. 
sudo chmod 777 /root/flask_deploy_script/$APP_DIR/myflaskapp.sock
sudo chmod a+x /root
sudo chmod a+x /root/flask_deploy_script

# Setup Nginx configuration
cat << EOF | sudo tee /etc/nginx/sites-available/myflaskapp
server {
    listen 80;
    server_name _;
    location / {
        include proxy_params;
        proxy_pass http://unix:/root/flask_deploy_script/$APP_DIR/myflaskapp.sock;
    }
}
EOF

# Enable the site and restart Nginx
sudo ln -sf /etc/nginx/sites-available/myflaskapp /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

echo "Deployment completed successfully!"
