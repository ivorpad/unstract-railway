#!/usr/bin/env bash

set -o nounset  # Exit if a variable is not set
# set -o errexit  # Removed to prevent silent failures

echo "Setting up Unstract..."

cd /app || exit 1

if [ -f "/app/docker/sample.env" ]; then
    echo "🔧 Setting up environment variables..."
    mv /app/docker/sample.env /app/docker/.env
else
    echo "Warning: sample.env not found in /app/docker!"
fi

if ! command -v docker-compose &>/dev/null; then
    echo "docker-compose not found! Exiting."
    exit 1
fi

cd /app/docker || exit 1
docker-compose up -d || {
    echo "Failed to start Unstract services!"
    exit 1
}

echo "Unstract is now running!"