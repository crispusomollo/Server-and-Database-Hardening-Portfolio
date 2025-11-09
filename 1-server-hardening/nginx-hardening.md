# Nginx Hardening Guide

Disable server tokens:
  ```nginx
  server_tokens off;
  ```

Use strong SSL config:
```
ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers on;
```

Limit request methods and size:
```
client_max_body_size 1M;
```
Enable rate limiting to prevent abuse.


