---
name: cicd-debugging
description: Guidelines and troubleshooting rules for containerized CI/CD pipelines, agent runtimes, trigger concurrency, and custom Docker network bridging.
---

# CI/CD Debugging and Ephemeral Orchestration

This skill provides architectural guidelines for designing, refactoring, and debugging containerized CI/CD pipelines, dynamic executors, and workflow agents.

## Guidelines

### 1. VCS Trigger Throttling and Concurrency Guard
* **Rule**: When configuring Version Control System (VCS) triggers for pipelines (webhooks, cron, or repository polling), always enable concurrency limits by default (e.g., aborting older concurrent runs or limiting active runs to 1).
* **Rationale**: Prevents build queue storms and executor exhaustion when build agents are offline or slow to provision.

### 2. Executor Network Context Alignment
* **Rule**: When deploying dynamic pipeline execution containers/nodes (such as ephemeral agents spawned by a controller) that must interact with auxiliary network services (e.g. scanners, artifact repositories, or databases), always ensure the execution agent is explicitly attached to the network context (Docker bridge network, overlay network, or Tailscale group) that permits DNS resolution and routing to those services.
* **Rationale**: Ephemeral runners often default to isolated bridges and will fail to resolve hostnames on custom project networks.

### 3. Orchestration-Agent Runtime Compatibility
* **Rule**: Match the runtime engine version (e.g., Java JRE, Node, Ruby) of the execution agent to the version of the controller.
* **Action**: Prefer using multi-stage Docker builds to copy known-good runtimes directly from official source images (e.g., copying `/opt/java/openjdk` from `eclipse-temurin:21-jre`), bypassing host package manager repository constraints.
