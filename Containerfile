FROM docker.io/osrf/ros:humble-desktop

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# Pre-configure keyboard and other packages that might ask questions
RUN echo 'keyboard-configuration keyboard-configuration/layout select English (US)' | debconf-set-selections && \
    echo 'keyboard-configuration keyboard-configuration/variant select English (US)' | debconf-set-selections && \
    echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections && \
    echo 'locales locales/locales_to_be_generated select en_US.UTF-8 UTF-8' | debconf-set-selections

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

# Create user (match your host user IDs)
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} hostuser && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -m hostuser && \
    echo "hostuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/hostuser

USER hostuser
WORKDIR /home/hostuser

# Configure environment for XWayland
RUN echo "export QT_QPA_PLATFORM=xcb" >> ~/.bashrc && \
    echo "export DISPLAY=:0" >> ~/.bashrc && \
    echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# Install Webots
RUN sudo mkdir -p /etc/apt/keyrings && \
    sudo wget -qO /etc/apt/keyrings/Cyberbotics.asc https://cyberbotics.com/Cyberbotics.asc && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/Cyberbotics.asc] https://cyberbotics.com/debian binary-amd64/" | sudo tee /etc/apt/sources.list.d/Cyberbotics.list && \
    sudo apt-get update && \
    sudo apt-get install -y webots ros-humble-webots-ros2