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

ARG freebsd_version=12.0-RELEASE

ENV CC=clang CXX=clang++ \
    URHO3D_PCH=0

RUN apt-get update && apt-get install -y --no-install-recommends clang \
    \
    # 64-bit FreeBSD sysroot
    && mkdir /amd64-sysroot && wget -qO- ftp://ftp2.jp.freebsd.org/pub/FreeBSD/releases/amd64/amd64/${freebsd_version}/base.txz |tar -xJC /amd64-sysroot ./lib/ ./usr/lib/ ./usr/include/ \
    \
    # 32-bit FreeBSD sysroot not yet supported
    && true

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/freebsd_entrypoint.sh"]

CMD rake cmake freebsd && rake make freebsd

# vi: set ts=4 sw=4 expandtab:
