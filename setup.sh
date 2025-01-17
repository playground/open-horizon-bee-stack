#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the repository URL and branch (modify as needed)
REPO_URL="https://github.com/i-am-bee/bee-stack.git"
CLONE_DIR="bee-stack"

# Stash local changes
git stash --include-untracked

if [ -d "$CLONE_DIR/.git" ]; then
  echo "Directory '$CLONE_DIR' exists and is a git repository. Pulling latest changes..."
  cd "$CLONE_DIR"
  git pull
else
  echo "Directory '$CLONE_DIR' does not exist or is not a git repository. Cloning..."
  git clone "$REPO_URL"
fi

# Restore stashed changes
git stash pop || echo "No stash to apply."

# Get the current working directory's basename
current_dir=$(basename "$(pwd)")

# Check if the current directory is 'app'
if [ "$current_dir" == "app" ]; then
  # Navigate into the cloned repository
  cd "$CLONE_DIR" || { echo "Failed to cd into $CLONE_DIR"; exit 1; }
fi

echo "Current directory is: $(pwd)"

# For mount volume to work, copy otel-collector-config.yaml to /mms-shared/config.yaml and update mount volume to /mms-shared/config.yaml:/etc/otelcol-contrib/
cp otel-collector-config.yaml /mms-shared/config.yaml

# Path to your YAML file
yaml_file="docker-compose.yml"

# Replace the specified volume mapping
sed -i.bak 's|\.\/otel-collector-config\.yaml:/etc/otelcol-contrib/config\.yaml|/mms-shared/config.yaml:/etc/otelcol-contrib/|' "$yaml_file"

# Confirm the change
echo "Updated $yaml_file"

# Function to prompt the user with a yes/no question
ask_yes_no() {
    local prompt="$1"
    local response

    while true; do
        read -r -p "$prompt [yes/no]: " response
        case "$response" in
            [yY][eE][sS]|[yY]) echo "yes"; break ;;
            [nN][oO]|[nN]) echo "no"; break ;;
            *) echo "Invalid response. Please enter yes or no." ;;
        esac
    done
}

# Ensure setup.sh is executable
if [ -f "./bee-stack.sh" ]; then
  chmod +x ./bee-stack.sh
  echo "Executing bee-stack.sh..."
  # Check if .env file exists in the current directory
  if [ -f ".env" ]; then
    if [ "$(ask_yes_no ".env file already exists. Do you want to run setup anyway?")" = 'no' ]; then
      ./bee-stack.sh start
    else
      ./bee-stack.sh setup
    fi
  else
    ./bee-stack.sh setup
  fi
else
  echo "setup.sh not found in $CLONE_DIR."
  exit 1
fi
