# Start from the official ROS Humble image
FROM docker.io/osrf/ros:humble-desktop

# Allow custom user/group IDs via build arguments
ARG USER_ID=1000
ARG GROUP_ID=1000

# Create a non-root user matching your host user/group IDs
RUN groupadd -g ${GROUP_ID} hostuser && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -m hostuser && \
    # Add hostuser to sudoers (optional for ROS development)
    echo "hostuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/hostuser

# Create persistent ROS workspace directory and set ownership
RUN mkdir -p /home/hostuser/code && \
    chown -R ${USER_ID}:${GROUP_ID} /home/hostuser

# Configure environment for ROS
USER hostuser
WORKDIR /home/hostuser/code
ENV SHELL=/bin/bash

# Source ROS in bashrc (persists across container runs)
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc && \
    echo "source /home/hostuser/code/omni-1-ws/install/local_setup.bash" >> ~/.bashrc && \
    echo "neofetch" >> ~/.bashrc && \
    echo "echo 'ROS 2 Humble environment ready!'" >> ~/.bashrc && \
    echo "export WEBOTS_HOME=/usr/local/webots" >> ~/.bashrc && \
    sudo apt update && \
    sudo apt upgrade -y && \
    sudo apt install -y neofetch neovim btop wget && \
    sudo mkdir -p /etc/apt/keyrings && \
    cd /etc/apt/keyrings && \
    sudo wget -q https://cyberbotics.com/Cyberbotics.asc && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/Cyberbotics.asc] https://cyberbotics.com/debian binary-amd64/" | sudo tee /etc/apt/sources.list.d/Cyberbotics.list && \
    sudo apt update && \
    cd /home/hostuser/code && \
    sudo apt install -y ros-humble-webots-ros2 ros-humble-urdf-tutorial && \
    sudo DEBIAN_FRONTEND=noninteractive apt install keyboard-configuration -y && \
    sudo apt install -y webots
