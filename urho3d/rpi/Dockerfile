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

FROM weitjong/toolchains:armv8-rpi3-linux-gnueabihf AS arm-linux-gnueabihf

##

FROM weitjong/toolchains:aarch64-rpi3-linux-gnu AS aarch64-linux-gnu

##

FROM ubuntu:latest AS rpi-sysroot-builder

RUN apt-get update && apt-get install -y --no-install-recommends qemu-user-static wget xz-utils \
    \
    # Download root compressed file from the latest Raspberry Pi OS lite release
 && mkdir /sysroot && wget --no-check-certificate -qO- https://downloads.raspberrypi.org/raspios_lite_armhf/root.tar.xz |tar -xJC /sysroot \
    \
    # Prepare it to be chroot-ed
 && cp $(which qemu-arm-static) /sysroot/$(which qemu-arm-static) \
 && perl -pi -e 's/^/#/g' /sysroot/etc/ld.so.preload \
    \
    # Install Urho3D prerequisite packages in chroot jail
 && chroot /sysroot /bin/bash -c 'apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends libx11-dev libasound2-dev libpulse-dev libdbus-1-dev libreadline6-dev libssl-dev libudev-dev libevdev2' \
    \
 && mkdir -p /rpi-sysroot/usr && for d in opt lib usr/include usr/lib; do mv /sysroot/$d /rpi-sysroot/$(dirname $d); done \
    \
    # Fix broken symlinks
 && for l in $(find /rpi-sysroot -xtype l -name \*.so); do ln -sf /rpi-sysroot$(readlink $l) $l; done

##

FROM weitjong/sysroots:raspios_arm64 AS rpi64-sysroot-builder

RUN rm -rf /sysroot/home \
    \
    # Install Urho3D prerequisite packages in chroot jail
 && chroot /sysroot /bin/bash -c 'apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends libdrm-dev libgbm-dev libgles2-mesa-dev libx11-dev libasound2-dev libpulse-dev libdbus-1-dev libreadline6-dev libssl-dev libudev-dev libevdev2' \
    \
 && mkdir -p /rpi64-sysroot/usr && for d in lib usr/include usr/lib; do mv /sysroot/$d /rpi64-sysroot/$(dirname $d); done \
    \
    # Fix broken symlinks
 && for l in $(find /rpi64-sysroot -xtype l -name \*.so); do ln -sf /rpi64-sysroot$(readlink $l) $l; done

##

FROM urho3d/dockerized:latest

ENV PLATFORM=rpi \
    RPI32_PREFIX=/rpi-tools/arm-linux-gnueabihf/bin/arm-linux-gnueabihf RPI32_SYSROOT=/rpi-sysroot \
    RPI64_PREFIX=/rpi-tools/aarch64-linux-gnu/bin/aarch64-linux-gnu RPI64_SYSROOT=/rpi64-sysroot

# Copy prepared toolchain and sysroot from the builder stages
COPY --from=arm-linux-gnueabihf /toolchain/ /rpi-tools/
COPY --from=aarch64-linux-gnu /toolchain/ /rpi-tools/
COPY --from=rpi-sysroot-builder /rpi-sysroot/ /rpi-sysroot/
COPY --from=rpi64-sysroot-builder /rpi64-sysroot/ /rpi64-sysroot/

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/rpi_entrypoint.sh"]

CMD ["/usr/bin/rake"]

# vi: set ts=4 sw=4 expandtab:
