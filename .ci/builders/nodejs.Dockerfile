FROM node:20-bullseye-slim

WORKDIR /app

# Install JRE (required for Jenkins agent), Git, and Curl
RUN apt-get update && apt-get install -y \
    openjdk-17-jre-headless \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI
RUN curl -fsSL https://get.docker.com | sh

# Install Syft (SBOM generation)
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
