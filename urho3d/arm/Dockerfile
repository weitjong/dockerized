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

FROM weitjong/toolchains:arm-cortex_a15-linux-gnueabihf AS arm-linux-gnueabihf

##

FROM weitjong/toolchains:aarch64-unknown-linux-gnu AS aarch64-linux-gnu

##

FROM ubuntu:latest AS arm-sysroot-builder

RUN apt-get update && apt-get install -y --no-install-recommends lsb-release qemu-user-static wget xz-utils \
    \
    # Get the latest LTS codename
 && name=$(lsb_release -c |cut -d':' -f2 |xargs) \
    \
    # Download root compressed file from the matching Ubuntu cloud image
 && mkdir /sysroot && wget --no-check-certificate -qO- https://cloud-images.ubuntu.com/$name/current/$name-server-cloudimg-armhf-root.tar.xz |tar -xJC /sysroot \
    \
    # Prepare it to be chroot-ed
 && cp $(which qemu-arm-static) /sysroot/$(which qemu-arm-static) \
 && rm /sysroot/etc/resolv.conf && echo nameserver 8.8.8.8 >/sysroot/etc/resolv.conf \
    \
    # Install Urho3D prerequisite packages in chroot jail
 && chroot /sysroot /bin/bash -c 'apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends libgles2-mesa-dev libx11-dev libxcursor-dev libxext-dev libxi-dev libxinerama-dev libxrandr-dev libxrender-dev libxss-dev libxxf86vm-dev libasound2-dev libpulse-dev libdbus-1-dev libreadline6-dev libssl-dev libudev-dev' \
    \
 && mkdir -p /arm-sysroot/usr && for d in lib usr/include usr/lib; do mv /sysroot/$d /arm-sysroot/$(dirname $d); done \
    \
    # Fix broken symlinks
 && for l in $(find /arm-sysroot -xtype l -name \*.so); do ln -sf $(basename $(readlink $l)) $l; done

##

FROM ubuntu:latest AS arm64-sysroot-builder

RUN apt-get update && apt-get install -y --no-install-recommends lsb-release qemu-user-static wget xz-utils \
    \
    # Get the latest LTS codename
 && name=$(lsb_release -c |cut -d':' -f2 |xargs) \
    \
    # Download root compressed file from the matching Ubuntu cloud image
 && mkdir /sysroot && wget --no-check-certificate -qO- https://cloud-images.ubuntu.com/$name/current/$name-server-cloudimg-arm64-root.tar.xz |tar -xJC /sysroot \
    \
    # Prepare it to be chroot-ed
 && cp $(which qemu-aarch64-static) /sysroot/$(which qemu-aarch64-static) \
 && rm /sysroot/etc/resolv.conf && echo nameserver 8.8.8.8 >/sysroot/etc/resolv.conf \
    \
    # Install Urho3D prerequisite packages in chroot jail
 && chroot /sysroot /bin/bash -c 'apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends libgles2-mesa-dev libx11-dev libxcursor-dev libxext-dev libxi-dev libxinerama-dev libxrandr-dev libxrender-dev libxss-dev libxxf86vm-dev libasound2-dev libpulse-dev libdbus-1-dev libreadline6-dev libssl-dev libudev-dev' \
    \
 && mkdir -p /arm64-sysroot/usr && for d in lib usr/include usr/lib; do mv /sysroot/$d /arm64-sysroot/$(dirname $d); done \
    \
    # Fix broken symlinks
 && for l in $(find /arm64-sysroot -xtype l -name \*.so); do ln -sf $(basename $(readlink $l)) $l; done

##

FROM urho3d/dockerized:latest

ENV PLATFORM=arm \
    ARM32_PREFIX=/arm-tools/arm-linux-gnueabihf/bin/arm-linux-gnueabihf ARM32_SYSROOT=/arm-sysroot \
    ARM64_PREFIX=/arm-tools/aarch64-linux-gnu/bin/aarch64-linux-gnu ARM64_SYSROOT=/arm64-sysroot

# Copy prepared toolchain and sysroot from the builder stages
COPY --from=arm-linux-gnueabihf /toolchain/ /arm-tools/
COPY --from=aarch64-linux-gnu /toolchain/ /arm-tools/
COPY --from=arm-sysroot-builder /arm-sysroot/ /arm-sysroot/
COPY --from=arm64-sysroot-builder /arm64-sysroot/ /arm64-sysroot/

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/arm_entrypoint.sh"]

CMD ["/usr/bin/rake"]

# vi: set ts=4 sw=4 expandtab:
