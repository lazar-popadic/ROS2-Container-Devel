# Grant the Docker container access to your host's X server:

xhost +local:docker

## Build and run:

docker build -t ros2-humble-container .

docker run -it --rm -v /home/lazar/Code/ros/:/home/hostuser/ros --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --user="$(id -u):$(id -g)" ros2-humble-container

