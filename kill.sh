#!/bin/bash

tmux send-keys -t http2https.0 C-c
tmux kill-session -t http2https