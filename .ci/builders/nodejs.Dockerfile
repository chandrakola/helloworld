FROM eclipse-temurin:21-jre AS java-source

FROM node:20-bookworm-slim

WORKDIR /app

# Copy Java JRE from Temurin
COPY --from=java-source /opt/java/openjdk /opt/java/openjdk
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install Git, and Curl
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI
RUN curl -fsSL https://get.docker.com | sh

# Install a Dependency-Track-compatible Syft release (CycloneDX 1.6).
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin v1.44.0
