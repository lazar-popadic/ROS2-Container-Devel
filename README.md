### Build and run:

podman build -t ros2-humble-container -f=Containerfile

podman volume create ros2-volume

podman run -it --rm -v ros2-volume:/home/hostuser --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --env USER="hostuser" --env USERNAME="hostuser" --env HOME="/home/hostuser" --network=host ros2-humble-container

### Container setup:

- generisi ssh kljuc i dodaj ga na svoj github nalog
- ukoliko ne postoji .bashrc u ~, napravi ga i dodaj ono sto se echo-uje u Containerfile-u
