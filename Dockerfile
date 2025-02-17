# Start from the official ROS Humble image
FROM osrf/ros:humble-desktop

# Allow custom user/group IDs via build arguments
ARG USER_ID=1000
ARG GROUP_ID=1000

# Create a non-root user matching your host user/group IDs
RUN groupadd -g ${GROUP_ID} hostuser && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -m hostuser && \
    # Add hostuser to sudoers (optional for ROS development)
    echo "hostuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/hostuser

# Create persistent ROS workspace directory and set ownership
RUN mkdir -p /home/hostuser/ros && \
    chown -R ${USER_ID}:${GROUP_ID} /home/hostuser

# Configure environment for ROS
USER hostuser
WORKDIR /home/hostuser/ros
ENV SHELL=/bin/bash

# Source ROS in bashrc (persists across container runs)
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc && \
    echo "echo 'ROS Humble environment ready!'" >> ~/.bashrc

