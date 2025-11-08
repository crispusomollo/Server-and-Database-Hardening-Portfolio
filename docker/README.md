## How to use:
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

### Notes:
- Replace passwords with your own secure passwords.

- Oracle image used here is a popular free XE image on Docker Hub.

- Ports are mapped to standard DB ports.

- Volumes persist data between container restarts.

