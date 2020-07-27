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

FROM ubuntu:latest AS builder

ARG ftp_server=ftp://ftp1.us.freebsd.org/pub/FreeBSD/releases/amd64/amd64/
ARG freebsd_version=12.0-RELEASE

RUN apt-get update && apt-get install -y --no-install-recommends qemu-user-static wget xz-utils && \
    \
    # Download base compressed file from the specified FreeBSD release
    mkdir /sysroot && wget -qO- ${ftp_server}/${freebsd_version}/base.txz |tar -xJC /sysroot && \
    \
    # Prepare it to be chroot-ed
    cp $(which qemu-arm-static) /sysroot/$(which qemu-arm-static) && \
    \
    # Install Urho3D prerequisite packages in chroot jail
# It is not possible to execute FreeBSD binary using GNU/Linux QEMU user mode
#    chroot /sysroot /bin/sh -c 'echo TODO: at least we need X11' && \
    \
    # Fix broken symbolic links
    true

##

FROM urho3d/dockerized:latest

ENV CC=clang CXX=clang++ \
    URHO3D_PCH=0

RUN apt-get update && apt-get install -y --no-install-recommends clang && \
    \
    # 64-bit FreeBSD sysroot
    \
    # 32-bit FreeBSD sysroot not yet supported
    true

# Copy prepared sysroot from builder stage (64-bit only for now)
COPY --from=builder /sysroot/lib/ /amd64-sysroot/lib/
COPY --from=builder /sysroot/usr/include/ /amd64-sysroot/usr/include/
COPY --from=builder /sysroot/usr/lib/ /amd64-sysroot/usr/lib/

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/freebsd_entrypoint.sh"]

CMD rake cmake freebsd && rake make freebsd

# vi: set ts=4 sw=4 expandtab:
