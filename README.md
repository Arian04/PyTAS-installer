# Run PyTAS easily

## What is PyTAS?
Information about PyTAS can be found here: http://self-assembly.net/wiki/index.php/PyTAS

## What's the purpose of this repo?
I had a few issues running PyTAS. Firstly, it's a bit old. The newest Python version I could use to run
it was 3.9, which isn't too bad, but I also had to pin the dependencies to pretty old versions.
I wouldn't mind if that was all, but installing wxPython involved building wxWidgets, which not
only took a decent amount of time on my reasonably powerful system, it also repeatedly failed due to
missing build dependencies that wouldn't become satisfied even though I carefully made sure I had every
dependency required by the wxWidgets documentation. This repo is meant to help distribute it in a more
painless, portable manner.

## Methods of running

### Docker
I believe there are some negative security implications of this, but if you trust the image, then giving
it access to your X server should be fine.

```sh
# Make sure $USER is properly set in your user shell, and that $UID and $GID aren't set to root's values when you `sudo` a command

xhost +SI:localuser:$USER # allows your current local user to connect to the X server
sudo docker run --rm --ipc=host --user $UID:$GID --volume=/tmp/.X11-unix/:/tmp/.X11-unix/ -e DISPLAY -e XAUTHORITY ghcr.io/arian04/pytas:latest # runs the container in such a way that it can access the X server, deletes container on exit
```

TODO:

- add more methods of running
  - Use Pyoxidizer to build a portable binary
  - [nix](https://nixos.org/)?
- improve my current WIP method of running the GUI through Docker
  or just remove it if Pyoxidizer builds reliable binaries
