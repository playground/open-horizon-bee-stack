#!/bin/bash

# Obtain the container ID of the current (open-horizon-bee-stack) container
OHBS_CONTAINER_ID=$(cat /proc/self/cgroup | grep 'docker' | sed 's/.*\///')

# Monitor OHBS status
while true; do
  OHBS_STATUS=$(docker inspect --format '{{.State.Status}}' "$OHBS_CONTAINER_ID")

  # If the OHBS container is stopped, stop the related containers
  if [[ "$OHBS_STATUS" == "exited" || "$OHBS_STATUS" == "dead" ]]; then
      echo "OHBS container ($OHBS_CONTAINER_ID) has stopped."
      /app/bee-stack/bee-stack.sh stop
      break
  fi

  # Sleep for a while before checking again
  sleep 5
done