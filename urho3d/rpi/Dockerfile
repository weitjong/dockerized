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

FROM weitjong/toolchains:armv7-rpi2-linux-gnueabihf AS armv7-rpi2-linux-gnueabihf

RUN rm /home/ng/x-tools/armv7-rpi2-linux-gnueabihf/build.log.bz2 \
    && mv /home/ng/x-tools/armv7-rpi2-linux-gnueabihf/armv7-rpi2-linux-gnueabihf/sysroot/ /sysroot

##

FROM weitjong/toolchains:aarch64-rpi3-linux-gnu AS aarch64-rpi3-linux-gnu

RUN rm /home/ng/x-tools/aarch64-rpi3-linux-gnu/build.log.bz2 \
    && mv /home/ng/x-tools/aarch64-rpi3-linux-gnu/aarch64-rpi3-linux-gnu/sysroot/ /sysroot

##

FROM ubuntu:latest AS sysroot-builder

RUN apt-get update && apt-get install -y --no-install-recommends qemu-user-static wget xz-utils \
    \
    # Download root compressed file from the latest Raspberry Pi OS lite release
    && mkdir /sysroot && wget --no-check-certificate -qO- https://downloads.raspberrypi.org/raspios_armhf/root.tar.xz |tar -xJC /sysroot

    # Prepare it to be chroot-ed
RUN cp $(which qemu-arm-static) /sysroot/$(which qemu-arm-static) \
    && perl -pi -e 's/^/#/g' /sysroot/etc/ld.so.preload \
    \
    # Install Urho3D prerequisite packages in chroot jail
    && chroot /sysroot /bin/bash -c 'apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends libx11-dev libasound2-dev libpulse-dev libdbus-1-dev libreadline6-dev libssl-dev libudev-dev libevdev2' \
    \
    # Fix broken symbolic links
    && for l in $(find /sysroot/lib -xtype l); do ln -sf $(basename $(readlink $l)) $l; done \
    && for l in $(find /sysroot/usr/lib/arm-linux-gnueabihf -xtype l); do ln -sf ../../..$(readlink $l) $l; done

##

FROM urho3d/dockerized:latest

ENV RPI_PREFIX=/rpi-tools/armv7-rpi2-linux-gnueabihf/bin/armv7-rpi2-linux-gnueabihf \
    RPI64_PREFIX=/rpi-tools/aarch64-rpi3-linux-gnu/bin/aarch64-rpi3-linux-gnu \
    RPI_SYSROOT=/rpi-sysroot

# Copy prepared toolchain and sysroot from the builder stages
COPY --from=sysroot-builder /sysroot/opt/ /rpi-sysroot/opt/
COPY --from=sysroot-builder /sysroot/lib/ /rpi-sysroot/lib/
COPY --from=sysroot-builder /sysroot/usr/include/ /rpi-sysroot/usr/include/
COPY --from=sysroot-builder /sysroot/usr/lib/ /rpi-sysroot/usr/lib/
COPY --from=armv7-rpi2-linux-gnueabihf /sysroot/ /rpi-sysroot/
COPY --from=armv7-rpi2-linux-gnueabihf /home/ng/x-tools/ /rpi-tools/
COPY --from=aarch64-rpi3-linux-gnu /home/ng/x-tools/ /rpi-tools/

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/rpi_entrypoint.sh"]

CMD rake cmake rpi && rake make rpi

# vi: set ts=4 sw=4 expandtab:
