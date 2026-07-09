# Cloud Automation Lab

Hands-on project built to practice Cloud, DevOps and infrastructure automation concepts.

## Current architecture

- Python Flask API
- PostgreSQL database
- Docker containers
- Docker Compose orchestration
- Internal Docker DNS communication
- Persistent PostgreSQL volume
- Application health endpoint with database connectivity check

## Health endpoint

The API exposes a `/health` endpoint.

- `200 OK` when PostgreSQL is reachable
- `503 Service Unavailable` when the database is unavailable

## Roadmap

- CI/CD pipeline
- Terraform infrastructure
- AWS deployment
- Monitoring
- Kubernetes
