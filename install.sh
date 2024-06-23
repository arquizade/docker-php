#!/bin/bash

# Function to check if Docker Compose is installed
check_docker_compose() {
    if ! command -v docker compose &> /dev/null; then
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
docker compose up -d --build

# Install PHP dependencies with Composer
docker compose exec app-php composer install

# Set permissions for storage and bootstrap/cache
docker compose exec app-php sh -c "chown -R www-data:www-data storage bootstrap/cache"
docker compose exec app-php sh -c "find storage bootstrap/cache -type f ! -name '.gitignore' -exec chmod 664 {} \; -o -type d -exec chmod 775 {} \;"

# Generate application key
docker compose exec app-php php artisan key:generate

# Run migrations
docker compose exec app-php php artisan migrate

# Create the flag file to indicate the installation is done
touch "$FLAG_FILE"

echo "Installation completed successfully!"