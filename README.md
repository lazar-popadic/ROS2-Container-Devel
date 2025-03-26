### Build and run:

podman build -t ros2-humble-container -f=Containerfile

podman run -it --rm -v /home/lazar/code/ros/:/home/hostuser/code --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --user="$(id -u):$(id -g)" --network=host ros2-humble-container
