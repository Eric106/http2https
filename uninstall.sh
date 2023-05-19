#!/bin/bash

# Read the bind_name from bind.json
bind_name=$(jq -r '.bind_name' bind.json)

# Stop the service
sudo service "$bind_name" stop

# Remove the service using update-rc.d
sudo update-rc.d -f "$bind_name" remove

# Remove the service file from /etc/init.d
sudo rm "/etc/init.d/$bind_name"

# Remove the service initialization line from /etc/rc.local
sudo sed -i "/sudo service $bind_name start/d" /etc/rc.local

echo "The Linux service has been removed."

# Prompt whether to remove the conda environment
read -p "Do you want to remove the conda environment? (y/n): " remove_conda

if [[ $remove_conda == "y" || $remove_conda == "Y" ]]; then
    # Remove the conda environment
    conda env remove -n http2https
    echo "The conda environment 'http2https' has been removed."
else
    echo "The conda environment 'http2https' was not removed. Please handle it manually if needed."
fi

