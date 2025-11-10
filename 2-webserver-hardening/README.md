## Web Server Hardening — Nginx & Apache
**Path:** `2-webserver-hardening/docs/webserver-hardening.md`

**Overview**
This document provides practical, step-by-step hardening guidance for **Nginx** and **Apache** running on Ubuntu 22.04. Topics: server tokens, TLS configuration, strong ciphers, HSTS, security headers, limiting HTTP methods, TLS certificate recommendations, and verification.

**Goals**
- Remove server version info exposure
- Enforce modern TLS (TLS 1.2/1.3)
- Enable security headers (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)
- Reduce allowed HTTP methods to safe set

**Prerequisites**
- Nginx >= 1.18 or Apache 2.4 on Ubuntu 22.04
- TLS certificate (Let's Encrypt recommended) or internal PKI
- Backups of config files before editing

### Nginx — recommended settings and steps
1. Turn off server tokens and hide version:
```nginx
# in /etc/nginx/nginx.conf (http context)
server_tokens off;
```

Security headers file: */etc/nginx/conf.d/security-headers.conf*

```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
add_header Content-Security-Policy "default-src 'self';" always;
```

TLS server block example (site-specific config)

```nginx

server {
    listen 443 ssl http2;
    server_name example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
    ssl_prefer_server_ciphers on;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

    include /etc/nginx/conf.d/security-headers.conf;

    # Limit allowed methods
    if ($request_method !~ ^(GET|POST|HEAD)$ ) {
        return 405;
    }

    # root / proxy_pass ...
}
```

Reload Nginx:

```bash
sudo nginx -t && sudo systemctl reload nginx
```

---

### Apache — recommended settings and steps

1. Enable headers module:

```bash
sudo a2enmod headers
```

2. Create */etc/apache2/conf-available/security-headers.conf*

```apache
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-Content-Type-Options "nosniff"
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "no-referrer-when-downgrade"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
Header always set Content-Security-Policy "default-src 'self';"
```

3. Enable the config and reload:

```bash
sudo a2enconf security-headers
sudo systemctl reload apache2
```

4. Enforce TLS by configuring your VirtualHost to listen on 443 with certificate paths and strong SSL settings; disable TLS 1.0/1.1.


### HTTP Methods & Rate Limiting

- Limit allowed methods to GET, POST, HEAD (or whatever your app needs).
- Implement rate limiting (Nginx limit_req_zone / Apache mod_ratelimit or WAF).
- Use a WAF (ModSecurity + OWASP CRS) for higher protection.

### Certificate Management

- Use Let’s Encrypt for public TLS or internal CA for private infra.
- Automate renewal with certbot + systemd timers or cron.
- Store private keys with strict permissions (600, owner root) and consider HSM/KeyVault for production.

### Verification

- Use SSL Labs (or openssl s_client) to verify TLS configuration.
- Check that server_tokens off is active: curl -I https://example.com and confirm Server header does not reveal version.
- Confirm security headers exist:

```bash
curl -sI https://example.com | grep -E "Strict-Transport-Security|X-Frame-Options|Content-Security-Policy"
```

**Notes & trade-offs**

- CSP can break third-party scripts—test thoroughly.
- HSTS preload requires careful roll-out (ensure all subdomains support HTTPS).

**References**

- Mozilla SSL Configuration Generator
- OWASP secure headers guidance
