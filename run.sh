#!/bin/bash

path_script="$(cd "$(dirname "$0")" && pwd)"

tmux new-session -d -s http2https
tmux send-keys -t http2https.0 "cd $path_script " ENTER
tmux send-keys -t http2https.0 "conda activate http2https " ENTER
tmux send-keys -t http2https.0 "bash ./start_gunicorn.sh " ENTER
