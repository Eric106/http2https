#!/bin/bash

# Check the existence of the "conda" command
if ! command -v conda &> /dev/null; then
    echo "Conda not installed, please install Anaconda or Miniconda."
    exit 1
fi

# Check the existence of the "tmux" command
if ! command -v tmux &> /dev/null; then
    echo "tmux not installed, please install it with: sudo apt install tmux"
    exit 1
fi

# Execute a conda command
conda create -n http2https python==3.9.12 -y
eval "$(conda shell.bash hook)"
conda activate http2https
pip install -r requirements.txt

# Prompt for the IP address
read -p "Enter the IP address: " ip

# Prompt for the HTTP port
read -p "Enter the HTTP port: " http_port

# Prompt for the HTTPS port
read -p "Enter the HTTPS port: " https_port

# Prompt whether to generate self-signed certificate and key
read -p "Do you want to generate self-signed certificate and key? (y/n): " generate_ssl

if [[ $generate_ssl == "y" || $generate_ssl == "Y" ]]; then
    # Generate self-signed certificate and key
    openssl req -x509 -newkey rsa:4096 -nodes -out ssl/cert.pem -keyout ssl/key.pem -days 365
    ssl_cert="ssl/cert.pem"
    ssl_key="ssl/key.pem"
else
    # Prompt for the SSL certificate path
    read -p "Enter the SSL certificate path: " ssl_cert

    # Prompt for the SSL key path
    read -p "Enter the SSL key path: " ssl_key
fi

# Create the JSON file
echo '{
  "ip": "'"$ip"'",
  "http_port": '"$http_port"',
  "https_port": '"$https_port"',
  "ssl_cert": "'"$ssl_cert"'",
  "ssl_key": "'"$ssl_key"'"
}' > bind.json

echo "The parameters have been saved in the bind.json file."
