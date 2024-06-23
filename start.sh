#!/bin/bash

# Function to check if installation has been completed
check_installation_done() {
    if [ ! -f "./.install_done" ]; then
        echo "Installation has not been completed. Please run ./install.sh first."
        exit 1
    fi
}

# Call the function to check if installation is done
check_installation_done

# Start and build Docker containers
docker compose up -d --build

echo "Docker containers started successfully!"
