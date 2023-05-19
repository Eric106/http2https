#!/bin/bash

path_script="$(cd "$(dirname "$0")" && pwd)"
cd $path_script
bind_name=$(jq -r '.bind_name' bind.json)

tmux send-keys -t $bind_name.0 C-c
tmux kill-session -t $bind_name