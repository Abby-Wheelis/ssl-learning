# Generate Certs

```sh
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365
```

Make sure to set FQDN to localhost when generating the cert


# To use certs from openssl demo

1. generate certs using openssl/demos/certs
2. make sure to edit the mkcerts scripts, including the configuration file, to use localhost
3. copy over certs, compile cert chain file with server and intca certificates into `test_server_chain` file
4. run server, then client

If keys are too short: extend the length in the mkcerts script
If localhost is not supported - make sure both the script and the conf are configured for localhost
