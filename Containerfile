FROM docker.io/osrf/ros:jazzy-desktop

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install basic utilities
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    net-tools \
    iputils-ping \
    build-essential \
    software-properties-common \
    apt-utils \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create ubuntu with home directory
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu

# Create workspace inside home
RUN mkdir -p /home/ubuntu/ws && \
    chown -R ubuntu:ubuntu /home/ubuntu/ws

# Set working directory
WORKDIR /home/ubuntu/ws

# Locale setup
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Install X11 dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    xauth \
    libgl1-mesa-dri \
    libxcb-xinput0 \
    libxcb-xtest0 \
    libxkbcommon-x11-0 \
    neofetch \
    neovim \
    btop \
    keyboard-configuration \
    x11-apps \
    && rm -rf /var/lib/apt/lists/*

# # Setup ROS2
# RUN set -x && \
#     rm -f /usr/share/keyrings/ros*.gpg && \
#     rm -rf /etc/apt/sources.list.d/* && \
#     apt-get update && apt-get install -y curl gnupg2 && \
#     curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
#     echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu jammy main" > /etc/apt/sources.list.d/ros2.list && \
#     apt-get update

# Install Webots
RUN mkdir -p /etc/apt/keyrings && \
    wget -qO /etc/apt/keyrings/Cyberbotics.asc https://cyberbotics.com/Cyberbotics.asc && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/Cyberbotics.asc] https://cyberbotics.com/debian binary-amd64/" > /etc/apt/sources.list.d/Cyberbotics.list && \
    apt-get update && \
    apt-get install -y webots ros-jazzy-webots-ros2

# Install other ROS2 packages
RUN apt-get install -y python3 python3-pip python3-dev python3-setuptools && \
    apt-get install -y ros-jazzy-urdf-tutorial ros-jazzy-joint-state-publisher ros-jazzy-joint-state-publisher-gui ros-jazzy-nav2-msgs ros-jazzy-nav-msgs ros-jazzy-plotjuggler ros-jazzy-plotjuggler-ros  && \
    apt-get install -y python3-pybind11 ros-jazzy-pybind11-vendor python3.12-venv

# Configure environment for XWayland
RUN echo "export QT_QPA_PLATFORM=xcb" >> /home/ubuntu/.bashrc && \
    echo "export DISPLAY=:0" >> /home/ubuntu/.bashrc

# Fix ownership AFTER installs
RUN chown -R ubuntu:ubuntu /home/ubuntu

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Switch user
USER ubuntu

# Python venv
RUN python3 -m venv /home/ubuntu/venv
RUN /home/ubuntu/venv/bin/pip install --upgrade pip && \
    /home/ubuntu/venv/bin/pip install pyserial

RUN echo "source /opt/ros/jazzy/setup.bash" >> /home/ubuntu/.bashrc && \
    echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> /home/ubuntu/.bashrc && \
    echo "source /home/ubuntu/ws/install/local_setup.bash" >> /home/ubuntu/.bashrc && \
    echo "echo 'ROS 2 Jazzy environment ready!'" >> /home/ubuntu/.bashrc && \
    echo "export WEBOTS_HOME=/usr/local/webots" >> /home/ubuntu/.bashrc && \
    echo "source ~/venv/bin/activate" >> /home/ubuntu/.bashrc

# Set the default command
CMD ["/bin/bash"]