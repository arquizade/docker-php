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

# Ensure at least one argument is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <artisan_command> [additional_args...]"
  exit 1
fi

# Execute the artisan command with all provided arguments
$DOCKER_COMPOSE_CMD exec app-php php artisan "$@"
