Create ssl certificates
```console
admin@serverB:~/http2https$ openssl req -x509 -newkey rsa:4096 -nodes -out ssl/cert.pem -keyout ssl/key.pem -days 365
```