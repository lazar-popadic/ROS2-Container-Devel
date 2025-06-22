### Build a ros2 humble container:
ros2-build-container
### Create a persistant podman volume:
podman volume create --opt o=uid=1000,gid=1000 ros2-volume
### Start the container by running:
ros2-start
### If you need another interactive shell in the same container run:
ros2-enter
### If you started the container outside an interactive shell, stop it by running:
ros2-stop

---

### In order to use git with ssh, you must generate a new ssh key:
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
### and add it to your account:
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
### Clone the ros381 repository:
git clone git@github.com:Plus381Robotics/ros381.git

---

#### When you start the container you should see neofetch output. If you dont see it, then .bashrc is not created.
