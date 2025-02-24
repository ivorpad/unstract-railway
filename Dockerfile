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
RUN [ -f sample.env ] && mv sample.env .env || echo "⚠️ Warning: sample.env not found, skipping move."

# Return to /app as working directory
WORKDIR /app

# Copy and ensure `run.sh` is executable
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

# Expose necessary ports
EXPOSE 80 443 3000 8000 5432

# Start Unstract platform
CMD ["bash", "/app/run.sh"]