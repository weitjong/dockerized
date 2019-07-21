#
# Copyright (c) 2019 Yao Wei Tjong. All rights reserved.
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

ENV EMSDK_HOME=/emscripten-sdk \
    EMCC_SKIP_SANITY_CHECK=1

RUN apt-get update && apt-get install -y python \
    && git clone -q --depth 1 --branch incoming \
        https://github.com/urho3d$EMSDK_HOME.git $EMSDK_HOME \
    && cd $EMSDK_HOME \
    && ./emsdk activate --build=Release \
        sdk-incoming-64bit binaryen-master-64bit >/dev/null \
    && ./emsdk construct_env >/dev/null \
    && for compiler in emscripten/incoming/{emcc,em++}; \
        do \
            touch -d "$(git log -1 --format=%cd --date=short)" $compiler; \
        done

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/web_entrypoint.sh"]

CMD rake cmake web && rake make web

# vi: set ts=4 sw=4 expandtab:
