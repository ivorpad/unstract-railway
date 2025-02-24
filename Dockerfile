FROM debian:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    curl \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Install Docker Compose V2 manually
RUN curl -fsSL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-$(uname -m) -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Set working directory
WORKDIR /app

# Clone the Unstract repository
RUN git clone https://github.com/Zipstack/unstract.git .

# Move into the docker directory and set up the environment
WORKDIR /app/docker
RUN mv sample.env .env

# Return to /app as working directory
WORKDIR /app

COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

# Disable `set -o errexit` to prevent silent script exits
RUN sed -i 's/set -o errexit/#set -o errexit/' run-platform.sh

# Make the platform script executable
RUN chmod +x run-platform.sh

# Expose necessary ports
EXPOSE 80 443 3000 8000 5432

# Start Unstract platform
CMD ["bash", "/app/run.sh"]