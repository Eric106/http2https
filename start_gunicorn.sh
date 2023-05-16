#!/bin/bash

gunicorn -w=$(python modules/set_workers.py) --certfile ssl/cert.pem --keyfile ssl/key.pem -b $(python modules/set_server_ip.py) http2https:app