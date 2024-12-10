#!/bin/bash

# Obtain the container ID of the current (open-horizon-bee-stack) container
OHBS_CONTAINER_ID=$(cat /proc/self/cgroup | grep 'docker' | sed 's/.*\///')

# Monitor OHBS status
docker events --filter 'event=stop' | while read event
do
    # Extract the container name from the event
    STOPPED_CONTAINER=$(echo "$event" | grep -oP 'container:\K\S+')

    # Check if the stopped container is the parent container
    if [[ "$STOPPED_CONTAINER" == "$HBS_CONTAINER_ID" ]]; then
      echo "Parent container has been stopped. Shutting down related containers..."
      /app/bee-stack/bee-stack.sh stop
      sleep 45
      break
    fi
done

echo "Shutting down OHBS container."
sleep 10
exit 0