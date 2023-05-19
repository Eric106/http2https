#!/bin/bash

# Load the bind name from bind.json
bind_name=$(jq -r '.bind_name' bind.json)

# Stop the service
sudo service "$bind_name" stop

# Remove the service using update-rc.d
sudo update-rc.d -f "$bind_name" remove

# Remove the service file from /etc/init.d
sudo rm "/etc/init.d/$bind_name"

# Prompt whether to remove the Conda environment
read -p "Do you want to remove the Conda environment 'http2https'? (y/n): " remove_conda_env

if [[ $remove_conda_env == "y" || $remove_conda_env == "Y" ]]; then
    # Check the existence of the "conda" command
    if ! command -v conda &> /dev/null; then
        echo "Conda not installed, please install Anaconda or Miniconda to remove the environment."
        exit 1
    fi

    # Check if the 'http2https' environment exists
    if conda env list | grep -q "http2https"; then
        # Deactivate the current environment
        eval "$(conda shell.bash hook)"
        conda deactivate
        # Remove the 'http2https' environment
        conda env remove -n http2https

        echo "The 'http2https' Conda environment has been removed."
    else
        echo "The 'http2https' Conda environment does not exist."
    fi
fi

echo "The uninstallation process is complete."
