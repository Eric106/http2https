#!/bin/bash

workers=$(python modules/set_workers.py)
server_ip=$(python modules/set_server_ip.py)
cert_file=$(jq -r '.ssl_cert' bind.json)
key_file=$(jq -r '.ssl_key' bind.json)
gunicorn -w=$workers --certfile $cert_file --keyfile $key_file -b $server_ip http2https:app