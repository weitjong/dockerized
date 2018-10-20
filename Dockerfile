#
# Copyright (c) 2008-2018 the Urho3D project.
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

LABEL description="Dockerized build environment for Urho3D" \
      source-repo=https://github.com/urho3d/dockerized \
      binary-repo=https://hub.docker.com/u/urho3d

ENV PATH=/usr/lib/ccache:$PATH \
    USE_CCACHE=1 CCACHE_SLOPPINESS=pch_defines,time_macros CCACHE_COMPRESS=1 \
    HOST_UID=1000 HOST_GID=1000

RUN groupadd -g $HOST_GID urho3d && useradd -u $HOST_UID -g $HOST_GID -s /bin/bash urho3d \
    && apt-get update && apt-get install -y build-essential ccache cmake doxygen git graphviz rake sudo wget

VOLUME /home/urho3d
VOLUME /project_dir

WORKDIR /project_dir

COPY sysroot/ /

ENTRYPOINT ["/script_dir/entrypoint.sh"]

CMD ["/bin/bash"]

# vi: set ts=4 sw=4 expandtab:
