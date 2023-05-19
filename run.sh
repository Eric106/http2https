#!/bin/bash

path_script="$(cd "$(dirname "$0")" && pwd)"
cd $path_script
bind_name=$(jq -r '.bind_name' bind.json)

tmux new-session -d -s $bind_name
tmux send-keys -t $bind_name.0 "conda activate http2https " ENTER
tmux send-keys -t $bind_name.0 "cd $path_script " ENTER
tmux send-keys -t $bind_name.0 "bash start_gunicorn.sh" ENTER

