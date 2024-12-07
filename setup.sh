#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the repository URL and branch (modify as needed)
REPO_URL="https://github.com/i-am-bee/bee-stack.git"
CLONE_DIR="bee-stack"

# Check if the directory exists
if [ -d "$DIR_NAME" ]; then
  echo "Directory '$DIR_NAME' already exists. Skipping clone."
else
  # Clone the repository
  echo "Cloning repository from $REPO_URL..."
  git clone "$REPO_URL"
fi

# Navigate into the cloned repository
cd "$CLONE_DIR" || { echo "Failed to cd into $CLONE_DIR"; exit 1; }

# Ensure setup.sh is executable
if [ -f "./bee-stack.sh" ]; then
    chmod +x ./bee-stack.sh
    echo "Executing bee-stack.sh..."
    ./bee-stack.sh setup
else
    echo "setup.sh not found in $CLONE_DIR."
    exit 1
fi
