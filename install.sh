#!/bin/bash

DOCKER_COMPOSE_V1="docker-compose"
DOCKER_COMPOSE_V2="docker compose"

# Function to check if Docker Compose is installed and determine the version
check_docker_compose() {
    if command -v $DOCKER_COMPOSE_V1 &> /dev/null; then
        DOCKER_COMPOSE_CMD=$DOCKER_COMPOSE_V1
    elif command -v $DOCKER_COMPOSE_V2 &> /dev/null; then
        DOCKER_COMPOSE_CMD=$DOCKER_COMPOSE_V2
    else
        echo "Docker Compose is not installed. Please install Docker Compose and try again."
        exit 1
    fi
}

# Call the function to check for Docker Compose
check_docker_compose

# Define the flag file
FLAG_FILE="./.install_done"

# Create .env file from .env.example if it doesn't exist
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo ".env file created from .env.example."
    else
        echo ".env.example file not found. Please create an .env file."
        exit 1
    fi
fi

# Check if the installation has already been done
if [ -f "$FLAG_FILE" ]; then
    read -p "Installation has already been completed. Do you want to run the installation again? (yes/no): " choice
    case "$choice" in 
      yes|Yes|y|Y ) echo "Proceeding with installation...";;
      no|No|n|N ) echo "Exiting..."; exit 0;;
      * ) echo "Invalid choice. Exiting..."; exit 1;;
    esac
fi

# Build Docker containers
$DOCKER_COMPOSE_CMD up -d --build

# Install PHP dependencies with Composer
$DOCKER_COMPOSE_CMD exec app-php composer install

# Set permissions for storage and bootstrap/cache
$DOCKER_COMPOSE_CMD exec app-php sh -c "chown -R www-data:www-data storage bootstrap/cache"
$DOCKER_COMPOSE_CMD exec app-php sh -c "find storage bootstrap/cache -type f ! -name '.gitignore' -exec chmod 664 {} \; -o -type d -exec chmod 775 {} \;"

# Generate application key
$DOCKER_COMPOSE_CMD exec app-php php artisan key:generate

# Run migrations
$DOCKER_COMPOSE_CMD exec app-php php artisan migrate

# Create the flag file to indicate the installation is done
touch "$FLAG_FILE"

echo "Installation completed successfully!"
