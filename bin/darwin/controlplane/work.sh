#!/bin/bash
set -x
killall irssi
tmux send-keys -t local:1 "irssi"
tmux send-keys -t local:1 "Enter"
