# React Raspberry Pi Starter Project

This project serves as a boilerplate for future projects that aim to run React applications on a Raspberry Pi using Docker. The setup provides a streamlined process for building a Docker image on a development machine, transferring the image to a Raspberry Pi, and running the application within a Docker container on the Raspberry Pi.

## Setup

### Raspberry Pi

Ensure you have the latest version of Raspberry Pi OS installed on your Raspberry Pi. This project assumes that you have Docker installed on your Raspberry Pi. If not, you can install it by running the following commands:

```bash
sudo apt update
sudo apt upgrade
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi
```
After installing Docker, restart your Raspberry Pi.

You should also set a static IP address for your Raspberry Pi to avoid IP conflicts. This can be done by editing the `dhcpcd.conf` file:

```bash
sudo nano /etc/dhcpcd.conf
```

In the opened file, add or uncomment and edit the following lines to set your desired static IP:

```bash
interface eth0
static ip_address=192.168.1.XX/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1
```
Replace `XX` with your desired IP address. Save the file and exit. You may need to restart the Raspberry Pi for changes to take effect.

### Build, Save and Transfer the Docker Image

With the provided scripts in the `package.json` file, you can build a Docker image, save it to a `.tar` file, and transfer it to your Raspberry Pi over SSH.

First, ensure you've built the Docker image:

```bash
yarn docker:build
```
This will build the Docker image using the Dockerfile in your project. The image will be tagged as `your-docker-username/your-image-name:version-tag`.

The command `yarn docker:deploy` already includes the build and save steps. It will:

1. Build the Docker image for the Raspberry Pi's ARMv7 architecture.
2. Save the Docker image as a `.tar` file in the `./docker-tars` directory of your project.
3. Transfer the `.tar` file to your Raspberry Pi using `scp`.

To deploy the Docker image to your Raspberry Pi:

```bash
yarn docker:deploy
```
This will use `scp` to transfer the `.tar` file over SSH to your Raspberry Pi. Be sure to replace the `username@raspberrypi-ip:/path/to/destination` placeholder with your Raspberry Pi's actual IP address and destination path.

### Running the Docker Container on Raspberry Pi

Once the Docker image is on your Raspberry Pi, you can load the image into Docker and run the container.

Load the Docker image:

```bash
docker load -i /path/to/your-image-name.tar
```
Run the Docker container:

```bash
docker run -p 3000:80 -d --name your-container-name your-docker-username/your-image-name:version-tag
```
The application should now be running in a Docker container on your Raspberry Pi, accessible at `http://<your-pi-ip>:3000`.

## Automating Container Deployment

The `run_docker.sh` script is included in this project to streamline the process of stopping and removing old Docker containers and images, loading the new Docker image, and running the new Docker container on your Raspberry Pi.

This script contains the following steps:

1. It stops and removes the old container if it exists.
2. It removes the old Docker image if it exists.
3. It loads the new Docker image from the `pi-server.tar` file.
4. It runs the new Docker container.

To use this script, place it in the same directory where the `pi-server.tar` file is located on your Raspberry Pi. Before running the script for the first time, ensure that it has the appropriate permissions:

```bash
chmod +x ./run_docker.sh
```

Then, simply run the script:

```bash
./run_docker.sh
```