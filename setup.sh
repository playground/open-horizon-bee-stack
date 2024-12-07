#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the repository URL and branch (modify as needed)
REPO_URL="https://github.com/i-am-bee/bee-stack.git"
CLONE_DIR="bee-stack"

if [ -d "$CLONE_DIR/.git" ]; then
  echo "Directory '$CLONE_DIR' exists and is a git repository. Pulling latest changes..."
  cd "$CLONE_DIR"
  git pull
else
  echo "Directory '$CLONE_DIR' does not exist or is not a git repository. Cloning..."
  git clone "$REPO_URL"
fi

# Navigate into the cloned repository
cd "$CLONE_DIR" || { echo "Failed to cd into $CLONE_DIR"; exit 1; }

# Ensure setup.sh is executable
if [ -f "./bee-stack.sh" ]; then
    cp ../bee-stack.sh .
    chmod +x ./bee-stack.sh
    echo "Executing bee-stack.sh..."
    ./bee-stack.sh setup
else
    echo "setup.sh not found in $CLONE_DIR."
    exit 1
fi
