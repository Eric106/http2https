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

# Prompt whether to use a custom bind name
read -p "Do you want to use a custom bind name? (y/n): " use_custom_name

if [[ $use_custom_name == "y" || $use_custom_name == "Y" ]]; then
    # Prompt for the custom bind name
    read -p "Enter the custom bind name: " bind_name

    # Save the current directory name
    current_dir=$(basename "$(pwd)")

    # Move up one level in the directory hierarchy
    cd ..

    # Rename the current directory
    mv "$current_dir" "$bind_name"

    # Enter the renamed directory
    cd "$bind_name"
else
    bind_name="http2https"
fi

# Create the JSON file
echo '{
  "ip": "'"$ip"'",
  "http_port": '"$http_port"',
  "https_port": '"$https_port"',
  "ssl_cert": "'"$ssl_cert"'",
  "ssl_key": "'"$ssl_key"'",
  "bind_name": "'"$bind_name"'"
}' > bind.json

echo "The parameters have been saved in the bind.json file."

# Prompt whether to install Linux service
read -p "Do you want to install the Linux service? (y/n): " install_service

if [[ $install_service == "y" || $install_service == "Y" ]]; then
    # Get the current username
    username=$(whoami)

    # Check if the user has sudo access
    if ! sudo -n true 2>/dev/null; then
        echo "This script requires sudo access. Please run the script with sudo privileges."
        exit 1
    fi

    # Get the current script's directory path
    path_script="$(cd "$(dirname "$0")" && pwd)"
    # Read the content of the http2https service file
    service_content=$(cat ./etc/init.d/http2https)

    # Modify the lines containing user and workdir with the obtained values
    service_content="${service_content//user=admin/user=$username}"
    service_content="${service_content//workdir=\/home\/admin\/http2https/workdir=$path_script}"

    # Write the modified service file to /etc/init.d/
    echo "$service_content" | sudo tee "/etc/init.d/$bind_name" >/dev/null
    # Give execution permissions to the service file
    sudo chmod +x "/etc/init.d/$bind_name"

    # Add the service with update-rc.d
    sudo update-rc.d "$bind_name" defaults

    # Check if the /etc/rc.local file exists
    if [[ -f /etc/rc.local ]]; then
        # Check if the service initialization line already exists in /etc/rc.local
        if ! sudo grep -q "sudo service $bind_name start" /etc/rc.local; then
            # Add the service initialization before the last "exit 0" instruction
            sudo sed -i '$i \sudo service '"$bind_name"' start\n' /etc/rc.local
        fi
    else
        # Write the content of the current directory's ./etc/rc.local file
        sudo cp ./etc/rc.local /etc/rc.local
        # Add the service initialization before the last "exit 0" instruction
        sudo sed -i '$i \sudo service '"$bind_name"' start\n' /etc/rc.local
    fi

    # Give execution permissions to /etc/rc.local
    sudo chmod +x /etc/rc.local
    sudo service "$bind_name" start
    echo "The Linux service has been installed."
fi
