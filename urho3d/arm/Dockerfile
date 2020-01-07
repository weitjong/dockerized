#
# Copyright (c) 2019-2020 Yao Wei Tjong. All rights reserved.
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

FROM ubuntu:latest AS builder-armhf

RUN apt-get update && apt-get install -y --no-install-recommends lsb-release qemu-user-static wget xz-utils \
    \
    # Get the latest LTS codename
    && name=$(lsb_release -c |cut -d':' -f2 |xargs) \
    \
    # Download root compressed file from the matching Ubuntu cloud image
    && mkdir /sysroot && wget --no-check-certificate -qO- https://cloud-images.ubuntu.com/$name/current/$name-server-cloudimg-armhf-root.tar.xz |tar -xJC /sysroot

    # Prepare it to be chroot-ed
RUN cp $(which qemu-arm-static) /sysroot/$(which qemu-arm-static) \
    && rm /sysroot/etc/resolv.conf && echo nameserver 8.8.8.8 >/sysroot/etc/resolv.conf \
    \
    # Install Urho3D prerequisite packages in chroot jail
    && chroot /sysroot /bin/bash -c 'apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends libgles2-mesa-dev libx11-dev libxcursor-dev libxext-dev libxi-dev libxinerama-dev libxrandr-dev libxrender-dev libxss-dev libxxf86vm-dev libasound2-dev libpulse-dev libdbus-1-dev libreadline6-dev libudev-dev' \
    \
    # Fix broken symbolic links
    && for l in $(find /sysroot/usr/lib/arm-linux-gnueabihf -xtype l); do ln -sf ../../..$(readlink $l) $l; done

##

FROM ubuntu:latest AS builder-arm64

RUN apt-get update && apt-get install -y --no-install-recommends lsb-release qemu-user-static wget xz-utils \
    \
    # Get the latest LTS codename
    && name=$(lsb_release -c |cut -d':' -f2 |xargs) \
    \
    # Download root compressed file from the matching Ubuntu cloud image
    && mkdir /sysroot && wget --no-check-certificate -qO- https://cloud-images.ubuntu.com/$name/current/$name-server-cloudimg-arm64-root.tar.xz |tar -xJC /sysroot

    # Prepare it to be chroot-ed
RUN cp $(which qemu-aarch64-static) /sysroot/$(which qemu-aarch64-static) \
    && rm /sysroot/etc/resolv.conf && echo nameserver 8.8.8.8 >/sysroot/etc/resolv.conf \
    \
    # Install Urho3D prerequisite packages in chroot jail
    && chroot /sysroot /bin/bash -c 'apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends libgles2-mesa-dev libx11-dev libxcursor-dev libxext-dev libxi-dev libxinerama-dev libxrandr-dev libxrender-dev libxss-dev libxxf86vm-dev libasound2-dev libpulse-dev libdbus-1-dev libreadline6-dev libudev-dev' \
    \
    # Fix broken symbolic links
    && for l in $(find /sysroot/usr/lib/aarch64-linux-gnu -xtype l); do ln -sf ../../..$(readlink $l) $l; done

##

FROM urho3d/dockerized:latest

ARG tool_version=5.5.0-2017.10-x86_64
ARG armhf_triplet=arm-linux-gnueabihf
ARG arm64_triplet=aarch64-linux-gnu

ENV ARMHF_PREFIX=/gcc-linaro-${tool_version}_$armhf_triplet/bin/$armhf_triplet \
    ARM64_PREFIX=/gcc-linaro-${tool_version}_$arm64_triplet/bin/$arm64_triplet \
    ARMHF_SYSROOT=/armhf-sysroot \
    ARM64_SYSROOT=/arm64-sysroot

RUN for triplet in $armhf_triplet $arm64_triplet; do tool=gcc-linaro-${tool_version}_$triplet \
        && wget -qO- https://releases.linaro.org/components/toolchain/binaries/latest-5/$triplet/$tool.tar.xz |tar -xJ; done

# Copy prepared sysroot from builder stage
COPY --from=builder-armhf /sysroot/opt/ /armhf-sysroot/opt/
COPY --from=builder-armhf /sysroot/lib/ /armhf-sysroot/lib/
COPY --from=builder-armhf /sysroot/usr/include/ /armhf-sysroot/usr/include/
COPY --from=builder-armhf /sysroot/usr/lib/ /armhf-sysroot/usr/lib/
COPY --from=builder-arm64 /sysroot/opt/ /arm64-sysroot/opt/
COPY --from=builder-arm64 /sysroot/lib/ /arm64-sysroot/lib/
COPY --from=builder-arm64 /sysroot/usr/include/ /arm64-sysroot/usr/include/
COPY --from=builder-arm64 /sysroot/usr/lib/ /arm64-sysroot/usr/lib/

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/arm_entrypoint.sh"]

CMD rake cmake arm && rake make arm

# vi: set ts=4 sw=4 expandtab:
