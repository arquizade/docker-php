# Laravel Docker Containerization Setup
This repository contains a Docker-based setup for running a Laravel application. It includes scripts for installation (`install.sh`), starting (`start.sh`), and stopping (`stop.sh`) the Docker containers.

## Prerequisites
Before you begin, ensure you have the following installed on your machine:
- Docker
- Docker Compose
  
## Installation
1. Clone this repository to your local machine:
	```bash
	git clone git@github.com:arquizade/docker-php.git
	cd docker-php
	```

2. **Install Docker Compose**: If Docker Compose is not installed, please install it using the official Docker documentation.
https://docs.docker.com/compose/install/

3. **Run Installation Script**: Execute the `install.sh` script to set up the Laravel environment:
	```bash
	./install.sh
	```
	This script will:
	-   Check for Docker Compose installation
	-   Create a `.env` file from `.env.example` if it doesn't exist
	-   Check if the installation has already been done using `.install_done`
	-   Build Docker containers, install PHP dependencies with Composer, set permissions for `storage`, and generate the application key

## Starting the Application
To start the Laravel application in Docker containers:
```bash
./start.sh
```
This script will:
-   Check if Docker Compose is installed
-   Check if the installation (`./install.sh`) has been completed (`./.install_done`)
-   Start the Docker containers (`docker-compose up -d --build`)

## Stopping the Application
To stop and remove the Docker containers:
```bash
./stop.sh
```

## Notes
-   Ensure Docker is running and accessible on your machine before running these scripts.
-   Make sure to configure any additional settings or environment variables in `.env` as needed for your Laravel application.
-   Customize `docker-compose.yml`, `Dockerfile`, and other Docker-related files according to your project requirements.
