# Flask Deployment Script

Script for deploying a Flask application using Gunicorn and Nginx on a Ubuntu server. The script sets up a virtual environment, installs necessary dependencies, and configures both Gunicorn and Nginx to serve a simple Flask application. Working on the smallest digital ocean box. 

The script will do the following.
      Update the server packages.
      Install Python3, Python3-venv, and Nginx.
      Set up a Python virtual environment.
      Install Flask and Gunicorn.
      Configure and enable a Gunicorn service to run the Flask app. (made this public for any user to ease of use, can change permission as needed)
      Set permissions for the Gunicorn socket.
      Configure Nginx to reverse proxy to Gunicorn.
      Restart and enable the necessary services.****


## Installation

1. **Clone the Repository**

   Clone the repository to your local machine or server:

   ```bash
   git clone https://github.com/tunahorse/flask_deploy_script.git
   cd flask_deploy_script
   chmod +x deploy_flask_app.sh

  

3. run script with /dir name. Ive made a simple flask app for a demo.
   
    ```bash
   ./deploy_flask.sh helloworld

      
     
