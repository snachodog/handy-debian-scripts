#!/bin/bash

# Variables
CONTAINER_NAME="yacreader"
LIBRARY_PATH="/comics"
COMMAND="YACReaderLibraryServer update-library"

# Check if the container is running
if docker ps --format "{{.Names}}" | grep -q "^$CONTAINER_NAME$"; then
    echo "Container '$CONTAINER_NAME' is running. Executing the update command..."
    docker exec "$CONTAINER_NAME" $COMMAND "$LIBRARY_PATH"
    if [ $? -eq 0 ]; then
        echo "Library update completed successfully."
    else
        echo "An error occurred while updating the library."
        exit 1
    fi
else
    echo "Error: Container '$CONTAINER_NAME' is not running."
    exit 1
fi

