build:
	docker build . -t ghcr.io/arian04/pytas:latest
run:
	# This is a bad way to run an appplication honestly, but I'm working on improving it
	xhost +SI:localuser:$(id -un)
	docker run --rm --name PyTAS --ipc=host --user $(id -u):$(id -g) --volume=/tmp/.X11-unix/:/tmp/.X11-unix/ -e DISPLAY -e XAUTHORITY ghcr.io/arian04/pytas:latest
