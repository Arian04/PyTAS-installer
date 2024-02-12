build:
	docker build . -t pytas:latest
run:
	# This is a bad way to run an appplication honestly, but I'm working on improving it
	xhost +SI:localuser:$(id -un)
	docker run --rm --name PyTAS --ipc=host --user $(id -u):$(id -g) --volume=${XAUTHORITY} -e DISPLAY -e XAUTHORITY -it pytas:latest
