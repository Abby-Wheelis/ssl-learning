# Generate Certs

```sh
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365
```

Make sure to set FQDN to localhost when generating the cert
