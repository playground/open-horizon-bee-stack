#!/bin/bash

# Function to handle stop signal (SIGTERM)
on_exit() {
  echo "OHBS container stopping... executing stop script."
  /app/bee-stack/bee-stack.sh stop
  sleep 45
}
# Trap SIGTERM signal and execute `on_exit`
trap on_exit SIGTERM
# Start the main process (e.g., your app)
echo "Starting main container process..."

