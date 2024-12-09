#!/bin/bash

# Function to handle stop signal (SIGTERM)
on_exit() {
  echo "Main container stopping... executing stop script."
  /app/bee-stack/bee-stack.sh stop
}

# Trap SIGTERM signal and execute `on_exit`
trap on_exit SIGTERM

# Start the main process (e.g., your app)
echo "Starting main container process..."
exec "$@"
