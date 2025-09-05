#!/usr/bin/env pwsh

# Check if X server is running (assuming you're using VcXsrv or similar)
$xProcess = Get-Process | Where-Object {$_.ProcessName -like "*X*server*" -or $_.ProcessName -like "*vcxsrv*" -or $_.ProcessName -like "*xorg*"}
if (!$xProcess) {
    Write-Host "X server not detected. Please start your X server (e.g., VcXsrv) first."
    exit 1
}

& "C:\Program Files\VcXsrv\xhost.exe" "+local:" 2>$null

# Get the WSL Hyper-V adapter IP address automatically
$wslIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "vEthernet (WSL*" | Where-Object {$_.IPAddress -like "172.*"}).IPAddress

podman run -it --rm `
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw `
    -v ros2-volume:/home/hostuser `
    -e "DISPLAY=$wslIP`:0" `
    -e QT_QPA_PLATFORM=xcb `
    -e XDG_RUNTIME_DIR=/tmp `
    -v /usr/lib/wsl/lib:/usr/lib/wsl/lib --device /dev/dxg:/dev/dxg `
    --security-opt label=disable `
    --group-add=video `
    --network=host `
    ros2-humble-container
