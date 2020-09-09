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

# Android dockerized build environment for Urho3D

This branch of the repo contains the information to build and run the Android DBE
for Urho3D.

Although the main purpose of this docker image is to build Urho3D project, any
Urho3D downstream projects that reuse Urho3D build system may benefit from the
dockerized build environment as well. Thus, you can just simply substitute all the
references to Urho3D project in the README.md with your own project.

## Building

You do not need to build this docker image yourself unless you want to change the
default build arguments.

|Build arg|Default|Description|
|---------|-------|-----------|
|tool_url|https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip|Android SDK Command line tools|
|tool_version|29.0.2|Build tool version|
|ndk_version|21.3.6528147|NDK (side by side) version|
|platforms|18,21,30|To keep the docker image small, only the listed API levels will be kept|

```
$ docker build --build-arg platforms=21,28 --tag=urho3d/dockerized-android .
```

## Running

The Clang compiler toolchain provided by NDK supports 4 ABIs: x86, x86_64,
armeabi-v7a, and arm64-v8a. By default The GCC compiler toolchain is not being 
supported anymore. The container's entry point calls the command `rake` that delegates
to `./gradlew build`, which by default build all the ABIs in one go. However, this will
consume a lot of memory (>8GB). In order to perform a split ABI build, you can pass
the command to run by the container explicitly with extra parameter for Gradle. For
example, run the Android DBE as below to perform a armeabi-v7a build.

```
$ docker run -it --rm \
    --mount type=bind,source=/host-path/to/urho3D,target=/local-path/to/urho3d \
    -e PROJECT_DIR=/local-path/to/urho3d \
    -e HOST_UID=1234 -e HOST_GID=1234 \
    urho3d/dockerized-android ./gradlew -P ANDROID_ABI=armeabi-v7a build
```

When the container finishes running, all the build artifacts can be found in the
build tree. Some of the build options supported by Urho3D's CMake build script can be
passed via Gradle as parameter in the similar fashion. For example, to build a shared
library type, one can run the container as below.

```
$ docker run -it --rm \
    --mount type=bind,source=/host-path/to/urho3D,target=/local-path/to/urho3d \
    -e PROJECT_DIR=/local-path/to/urho3d \
    -e HOST_UID=1234 -e HOST_GID=1234 \
    urho3d/dockerized-android ./gradlew -P URHO3D_LIB_TYPE=SHARED build
```

## Running using convenient shell script in Urho3D project

To build using the default command is as simple as below.

```
script/dockerized.sh android
```
