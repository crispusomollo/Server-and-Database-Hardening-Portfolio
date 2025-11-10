## Docker Hardening
**Path:** `4-docker-hardening/docs/docker-hardening.md`

### Overview
Guidance to harden Docker daemon, images, and containers. Focuses on daemon configuration (`daemon.json`), limiting privileges, using user namespaces, image hygiene, and logging.

### Goals
- Reduce host attack surface
- Limit container capabilities and privileges
- Secure daemon access and communications
- Ensure image provenance and minimal base images

### Key Recommendations
1. **Daemon configuration** (`/etc/docker/daemon.json`):
   - Enable user namespaces (if desired)
   - Configure log rotation
   - Disable experimental features in production
   - If exposing dockerd remotely, enable TLS authentication

2. **User & permissions**
   - Do **not** run containers as root when avoidable — use `USER` in Dockerfile
   - Avoid adding users to `docker` group for sensitive hosts (docker group grants root-equivalent privileges)

3. **Capabilities & seccomp**
   - Drop unnecessary Linux capabilities:
     ```yaml
     # docker run example
     docker run --cap-drop ALL --cap-add CHOWN --cap-add NET_BIND_SERVICE ...
     ```
   - Use Docker’s default `seccomp` profile or custom restrictive profile

4. **Image hygiene**
   - Use minimal, official images (e.g., `alpine`, `debian:slim`)
   - Scan images for vulnerabilities (Trivy, Clair)
   - Pin explicit image versions/tags

5. **Networking**
   - Restrict ports with firewall; use private networks and overlay networks in orchestrators
   - Avoid host network mode unless necessary

6. **Secrets & configs**
   - Use Docker secrets, environment variable encryption, or a secret manager (Vault, AWS Secrets Manager)
   - Never bake secrets into images

7. **Runtime & cluster**
   - Limit resource usage (`--memory`, `--cpus`)
   - Enable read-only file systems for containers that don’t need write access (`--read-only`)

8. **Logging & monitoring**
   - Set `log-driver` and `log-opts` with rotation to prevent disk fill
   - Centralize logs to ELK/Prometheus/Grafana or cloud logging

#### Example minimal `daemon.json`
(See `daemon.json` sample provided separately.)

#### Verification
- `docker info` to check user namespaces, rootless mode
- Run vulnerability scan on local images
- Confirm `docker` service not reachable on public interfaces

#### Notes
- Running Docker on production hosts requires careful privilege management; consider container orchestration best-practices (Kubernetes + Pod Security Policies / OPA/Gatekeeper).

- Replace passwords with your own secure passwords.
- Oracle image used here is a popular free XE image on Docker Hub.
- Ports are mapped to standard DB ports.
- Volumes persist data between container restarts.

#### How to use:
```
cd docker
docker-compose up -d
```

PostgreSQL available on localhost:5432

MySQL available on localhost:3306

Oracle XE available on localhost:1521

To stop:
```
docker-compose down
```

