docker_build:
	docker build . -t ghcr.io/arian04/pytas:latest
docker_run:
	xhost +SI:localuser:$USER
	docker run --rm --ipc=host --user $UID:$GID --volume=/tmp/.X11-unix/:/tmp/.X11-unix/ -e DISPLAY -e XAUTHORITY ghcr.io/arian04/pytas:latest
