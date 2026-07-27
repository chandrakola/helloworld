FROM python:3.11-slim-bullseye

WORKDIR /app

# Install JRE, Git, and Curl
RUN apt-get update && apt-get install -y \
    openjdk-17-jre-headless \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI
RUN curl -fsSL https://get.docker.com | sh

# Install Syft
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
