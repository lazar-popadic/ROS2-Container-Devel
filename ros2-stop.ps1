#!/usr/bin/env pwsh

# Find the first running container with the image "ros2-humble-container"
$CONTAINER_ID = podman ps --filter "ancestor=ros2-humble-container" --format "{{.ID}}" | Select-Object -First 1

if ([string]::IsNullOrEmpty($CONTAINER_ID)) {
    Write-Host "Error: No running container with image 'ros2-humble-container' found."
    exit 1
} else {
    Write-Host "Stopping container: $CONTAINER_ID"
    podman stop "$CONTAINER_ID"

    # Verify it stopped
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully stopped container."
    } else {
        Write-Host "Failed to stop container (try 'podman kill $CONTAINER_ID')."
        exit 1
    }
