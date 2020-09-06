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

FROM urho3d/dockerized:latest

ARG VERSION=latest

ENV PLATFORM=web \
    EMSDK=/emsdk-master EMCC_SKIP_SANITY_CHECK=1

RUN apt-get update && apt-get install -y --no-install-recommends default-jre libxml2 python3 python3-distutils \
 && update-alternatives --install /usr/bin/python python /usr/bin/python3 3 \
 && wget -qO- https://github.com/emscripten-core/emsdk/archive/master.tar.gz |tar -xz \
 && cd $EMSDK \
 && ./emsdk update-tags \
 && ./emsdk install $VERSION \
 && ./emsdk activate $VERSION \
 && apt-get clean

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/web_entrypoint.sh"]

CMD ["/usr/bin/rake"]

# vi: set ts=4 sw=4 expandtab:
