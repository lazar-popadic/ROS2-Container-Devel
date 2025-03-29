#### Build a ros2 humble container:
podman build -t ros2-humble-container -f=Containerfile
#### Create a persistant podman volume:
podman volume create ros2-volume
#### Start the container by running:
ros2-start
#### If you need another interactive shell in the same container run:
ros2-enter
#### If you started the container outside an interactive shell, stop it by running:
ros2-stop


#### In order to use git with ssh, you must generate a new ssh key:
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
#### and add it to your account:
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account


##### When you start the container you should see neofetch output. If you dont see it, then .bashrc is not created. Create it on your own in the /home/hostuser directory, and add the following lines to it:
neofetch
source /opt/ros/humble/setup.bash
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
source /home/hostuser/omni-1-ws/install/local_setup.bash
echo 'ROS 2 Humble environment ready!'
export WEBOTS_HOME=/usr/local/webots
