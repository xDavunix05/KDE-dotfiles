#!/usr/bin/env bash
# Show ACTIVE if last tmux session activity was <5 minutes ago, else INACTIVE

# Get last tmux session activity time in epoch seconds
last_activity=$(tmux display-message -p "#{session_activity}" 2>/dev/null)

# Check if last_activity is a valid number
if ! [[ "$last_activity" =~ ^[0-9]+$ ]]; then
  # Could not get activity, assume INACTIVE
  echo "#[fg=red]INACTIVE#[default]"
  exit 0
fi

now=$(date +%s)

# Calculate idle time in seconds
idle=$(( now - last_activity ))

# Threshold: 300 seconds = 5 minutes
if [ "$idle" -ge 120 ]; then
  echo "#[fg=red]INACTIVE#[default]"
else
  echo "#[fg=green]ACTIVE#[default]"
fi
