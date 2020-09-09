<!--
  Copyright (c) 2018-2020 Yao Wei Tjong. All rights reserved.

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
-->

# Dockerized build environment for Urho3D

The master branch of this repo contains the information to build and run the base
image to which all the platform-specific descendant images are based on. The base
image is considered as abstract and should not be run directly in a container for
normal use case. Having said that, the base image is designed to be runnable so
that docker image builder may still want to do so during the development of a new
descendant image targeting a new platform.

This repo has a number of branches, one for each target platform. For more detail
see their individual README.md file.

- [Linux](https://hub.docker.com/r/urho3d/dockerized-linux/)
- [MinGW](https://hub.docker.com/r/urho3d/dockerized-mingw/)
- [Android](https://hub.docker.com/r/urho3d/dockerized-android/)
- [Raspberry-Pi](https://hub.docker.com/r/urho3d/dockerized-rpi/)
- [ARM](https://hub.docker.com/r/urho3d/dockerized-arm/)
- [Web](https://hub.docker.com/r/urho3d/dockerized-web/)

Although the main purpose of these docker images is to build Urho3D project, any
Urho3D downstream projects that reuse Urho3D build system may benefit from the
dockerized build environment as well. Thus, you can just simply substitute all the
references to Urho3D project in the README.md with your own project.

## Building

You do not need to build the base image yourself unless you want to change the
default build arguments.

|Build arg|Default|Description|
|---------|-------|-----------|
|lang|en_US.UTF-8|Language locale setting|
|cmake_version|3.14.5|CMake version|

e.g.
```
$ docker build --build-arg lang=en_SG.UTF-8 --tag=urho3d/dockerized .
```

## Running

As mentioned earlier, this is only intended for docker image builder. The base image
could be run to get a bash shell where image builder can install software packages
and try out Linux commands before "committing" them into a new Dockerfile for
building the descendant docker image.

Note that the Urho3D dockerized build environment run time is actually the build
time for the Urho3D project itself. So, in order to run the base image or any of
its descendant images, we need to at least pass in the location of the Urho3D
project root and ensure those files in the project root are accessible by the
running user inside the container. This is done by mounting the Urho3D project root
location from the host filesystem to a local location inside the running
container, then set the `PROJECT_DIR` environment variable to point to this local
location and set the `HOST_UID` & `HOST_GID` to the user ID & group ID of the
Urho3D project root owner in the host filesystem, e.g.

```
$ docker run -it --rm \
    --mount type=bind,source=/host-path/to/urho3D,target=/local-path/to/urho3d \
    -e PROJECT_DIR=/local-path/to/urho3d \
    -e HOST_UID=1234 -e HOST_GID=1234 \
    urho3d/dockerized
```

Type `exit` to exit the shell as usual. The shell process is invoked using
`urho3d` user ID. This user is only created inside the container on-the-fly (using
the specified UID and GID) and is able to use `sudo` command to install new
software packages as root without any password. Any new files created by the
`urho3d`, such as build artifacts, in the mounted (local) Urho3D project dir will
be visible and accessible in host filesystem by the owner of the Urho3D project
root even after the container has been stopped.

> WARNING: Any files deleted in the mounted Urho3D project dir inside the
container will be deleted permanently as well from the host filesystem!

Anything else created or deleted outside this mounted directory are just
temporary inside the container, i.e. they will be all gone anyway once the
container is stopped and removed. To commit such changes, the relevant
instructions must be scripted accordingly in a new Dockerfile as discussed at the
beginning of this chapter.

## Running using convenient shell script in Urho3D project

We have provided a convenient shell script to run a docker image in the Urho3D
project. It is called `dockerized.sh` under the `script` directory in the Urho3D
project root. Assuming the caller of the shell script is also the owner of the
Urho3D project root, simply type this below to run the base image.

```
$ script/dockerized.sh base
```

Refer to Urho3D project online documentation
[here](https://urho3d.github.io/documentation/HEAD/_building.html#Dockerized_Build_Environment)
for more detail.
