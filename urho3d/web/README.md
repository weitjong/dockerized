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

# Web dockerized build environment for Urho3D

This branch of the repo contains the information to build and run the Web DBE
for Urho3D.

Although the main purpose of this docker image is to build Urho3D project, any
Urho3D downstream projects that reuse Urho3D build system may benefit from the
dockerized build environment as well. Thus, you can just simply substitute all the
references to Urho3D project in the README.md with your own project.

## Building

|Build arg|Default|Description|
|---------|-------|-----------|
|VERSION|latest|EMSDK version to install, e.g.: tot-upstream|


```
$ podman build --build-arg VERSION=tot-upstream -t docker.io/urho3d/dockerized-web:tot urho3d/web
```

## Running

The container contains the EMCC compiler toolchain which is built from `Incoming`
branch of the Emscripten project targeting WASM by default. It can be run as below.

```
$ docker run -it --rm \
    --mount type=bind,source=/host-path/to/urho3D,target=/local-path/to/urho3d \
    -e PROJECT_DIR=/local-path/to/urho3d \
    -e HOST_UID=1234 -e HOST_GID=1234 \
    urho3d/dockerized-web
```

The container's entry point eventually calls the command `rake` with the default
task, which is equivalent to running `script/cmake_generic.sh build/web -D WEB=1
&& cd build/web && make` command. When the container finishes running, all the
build artifacts can be found in the build tree. Other build options supported by
Urho3D build system can be passed when running the container too by using "-e"
flag. For example to build a module library type targeting asm.js instead, one can
run the container as below.

```
$ docker run -it --rm \
    --mount type=bind,source=/host-path/to/urho3D,target=/local-path/to/urho3d \
    -e PROJECT_DIR=/local-path/to/urho3d \
    -e HOST_UID=1234 -e HOST_GID=1234 \
    -e URHO3D_LIB_TYPE=MODULE \
    -e EMSCRIPTEN_WASM=0 \
    urho3d/dockerized-web
```

## Running using convenient shell script in Urho3D project

To build using the default command is as simple as below.

```
$ script/dockerized.sh web
```
