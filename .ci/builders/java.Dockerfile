FROM maven:3.9.6-eclipse-temurin-21

WORKDIR /app

# Install Git and Curl
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI
RUN curl -fsSL https://get.docker.com | sh

# Install a Dependency-Track-compatible Syft release (CycloneDX 1.6).
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin v1.44.0
