#!/usr/bin/env pwsh

# Find the first running container with the image "ros2-humble-container"
$CONTAINER_ID = podman ps --filter "ancestor=ros2-humble-container" --format "{{.ID}}" | Select-Object -First 1

if ([string]::IsNullOrEmpty($CONTAINER_ID)) {
    Write-Host "Error: No running container with image 'ros2-humble-container' found."
    exit 1
} else {
    Write-Host "Entering container: $CONTAINER_ID"
    podman exec -it "$CONTAINER_ID" /bin/bash
}
