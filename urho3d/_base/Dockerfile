#
# Copyright (c) 2018-2020 Yao Wei Tjong. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

FROM ubuntu:latest

LABEL maintainer="Yao Wei Tjong <weitjong@gmail.com>" \
      description="Dockerized build environment for Urho3D" \
      source-repo=https://github.com/weitjong/dockerized \
      binary-repo=https://hub.docker.com/u/weitjong \
      retag-binary-repo=https://hub.docker.com/u/urho3d

ARG lang=en_US.UTF-8
ARG cmake_version=3.17.3
ARG time_zone=Asia/Singapore

ENV USE_CCACHE=1 CCACHE_SLOPPINESS=pch_defines,time_macros CCACHE_COMPRESS=1 \
    HOST_UID=1000 HOST_GID=1000 \
    DEBIAN_FRONTEND=noninteractive TZ=$time_zone

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Essential
    build-essential ccache git g++-multilib \
    \
    # Documentation
    doxygen graphviz locales \
    \
    # Misc.
    openssh-client rake rsync sudo tzdata vim wget \
    \
    # Download CMake directly from its provider
 && wget -qO- https://github.com/Kitware/CMake/releases/download/v$cmake_version/cmake-$cmake_version-Linux-x86_64.tar.gz |tar --strip-components=1 -xzC /usr/local \
    \
    # Setup default locale
 && locale-gen $lang && update-locale LANG=$lang \
    \
    # Clean up
 && apt-get clean

VOLUME /home/urho3d

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/bash"]

# vi: set ts=4 sw=4 expandtab:
