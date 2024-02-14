ARG BASE_IMAGE=python
ARG BASE_IMAGE_TAG=3.9.18-bullseye
#ARG BASE_IMAGE_TAG=3.9-bookworm # TODO: update base image to newer debian

##### Build Wheels #####
FROM $BASE_IMAGE:$BASE_IMAGE_TAG as builder_wheels

ENV PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /build

# install dependencies
RUN apt-get update -y && \
	apt-get -y --no-install-recommends install dpkg-dev build-essential python3.9-dev and libpython3.9-dev freeglut3-dev libgl1-mesa-dev libglu1-mesa-dev libgstreamer-plugins-base1.0-dev libgtk-3-dev libjpeg-dev libnotify-dev libpng-dev libsdl2-dev libsm-dev libtiff-dev libwebkit2gtk-4.0-dev libxtst-dev

# create wheel files
COPY requirements.txt .
RUN \
	pip install --no-cache-dir wheel==0.42.0 && \
	pip wheel --wheel-dir=./wheels -r requirements.txt

##### Get PyTAS Source #####
FROM $BASE_IMAGE:$BASE_IMAGE_TAG as builder_pytas

# checksum is compared to confirm that the file being downloaded is the expected one for security and reliability reasons
ENV PY_TAS_SOURCE_URL=http://self-assembly.net/software/PyTAS/PyTAS-source-2021-10-20-14-50-02.zip
ARG EXPECTED_SHA512="6a30604d8e5f9559b893b7dfcd04e5c4de474abfb480fe528ab4cb3e162345d32132f41766234d53a7b1369e06b9a7ea6a2c78a492e59fd8badbd635e709e973"

WORKDIR /build

# get pyTAS
RUN wget --progress=dot:giga "$PY_TAS_SOURCE_URL" -O ./pytas.zip

# verify checksum matches
RUN \
	echo "${EXPECTED_SHA512}  pytas.zip" > checksum.txt; \
	sha512sum --check --status checksum.txt

# extract source
RUN unzip pytas.zip

##### Runner #####
FROM $BASE_IMAGE:$BASE_IMAGE_TAG

ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# runtime dependencies (figured this out by running it and adding a package every time it said there was a .so file missing)
RUN apt-get update -y && \
	apt-get -y --no-install-recommends install libgtk-3-0 libxxf86vm1 libnotify4 libxtst6 libsdl2-2.0-0 libgl1 libegl1 && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# install wheel files
WORKDIR /build
COPY --from=builder_wheels /build /build
RUN pip install --no-cache-dir --no-index --find-links=/build/wheels -r /build/requirements.txt

WORKDIR /app

# copy PyTAS over
COPY --from=builder_pytas /build/PyTAS .

# command to run on container start
CMD [ "python", "./PyTAS.py" ]
