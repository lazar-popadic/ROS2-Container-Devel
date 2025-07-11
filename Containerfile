FROM docker.io/osrf/ros:humble-desktop

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# Pre-configure keyboard and other packages that might ask questions
RUN echo 'keyboard-configuration keyboard-configuration/layout select English (US)' | debconf-set-selections && \
    echo 'keyboard-configuration keyboard-configuration/variant select English (US)' | debconf-set-selections && \
    echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections && \
    echo 'locales locales/locales_to_be_generated select en_US.UTF-8 UTF-8' | debconf-set-selections

RUN set -x && \
    # Clean up any existing ROS keys and sources
    rm -f /usr/share/keyrings/ros*.gpg && \
    rm -f /etc/apt/sources.list.d/ros*.list && \
    # Install required tools
    apt-get update && apt-get install -y curl gnupg2 && \
    # Add new key
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    # Add repository (hardcoding jammy for certainty)
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu jammy main" > /etc/apt/sources.list.d/ros2.list && \
    # Update
    apt-get update

# Install X11 dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    xauth \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libxcb-xinput0 \
    libxcb-xtest0 \
    libxkbcommon-x11-0 \
    neofetch \
    neovim \
    btop \
    wget \
    keyboard-configuration \
    x11-apps \
    && rm -rf /var/lib/apt/lists/*

# Install Webots
RUN mkdir -p /etc/apt/keyrings && \
    wget -qO /etc/apt/keyrings/Cyberbotics.asc https://cyberbotics.com/Cyberbotics.asc && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/Cyberbotics.asc] https://cyberbotics.com/debian binary-amd64/" | sudo tee /etc/apt/sources.list.d/Cyberbotics.list && \
    apt-get update && \
    apt-get install -y webots ros-humble-webots-ros2 && \
    apt-get update

# Install other ROS2 packages
RUN apt-get install -y python3 python3-pip python3-dev python3-setuptools && \
    git clone --recurse-submodules https://github.com/cyberbotics/urdf2webots.git && \
    pip install --upgrade --editable urdf2webots && \
    apt-get install -y ros-humble-urdf-tutorial ros-humble-joint-state-publisher ros-humble-joint-state-publisher-gui

# Create user (match your host user IDs)
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} hostuser && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -m hostuser && \
    echo "hostuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/hostuser
USER hostuser
WORKDIR /home/hostuser

RUN touch /home/hostuser/.bashrc && \
    echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc && \
    echo "source /home/hostuser/ros381/install/local_setup.bash" >> ~/.bashrc && \
    echo "neofetch" >> ~/.bashrc && \
    echo "echo 'ROS 2 Humble environment ready!'" >> ~/.bashrc && \
    echo "export WEBOTS_HOME=/usr/local/webots" >> ~/.bashrc && \
    echo "eval \"\$(ssh-agent -s)\"" >> ~/.bashrc

# Configure environment for XWayland
RUN echo "export QT_QPA_PLATFORM=xcb" >> ~/.bashrc && \
    echo "export DISPLAY=:0" >> ~/.bashrc
