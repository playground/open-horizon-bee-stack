#!/bin/bash

# Define the action to perform when a container is stopped
on_container_stop() {
  local container_id="$1"
  local container_name=$(docker inspect --format '{{.Name}}' "$container_id" | sed 's/^\/\|\/$//g') # Remove leading/trailing slashes

  echo "Container stopped: $container_name ($container_id)"

  # Perform additional actions here, e.g., logging or stopping other containers
  # Example: Stop another container
  /app/bee-stack/bee-stack.sh stop
}

# Monitor Docker events for "stop" events
docker events --filter 'event=stop' --format '{{.ID}}' | while read -r container_id; do
  # Call the action function when a stop event occurs
  on_container_stop "$container_id"
done
