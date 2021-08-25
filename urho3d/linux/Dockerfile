#
# Copyright (c) 2018-2021 Yao Wei Tjong. All rights reserved.
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

FROM weitjong/dockerized:urho3d-base AS libdecor-builder

ARG libdecor_ver=0.1.0

RUN apt update && apt upgrade -y && apt install -y --no-install-recommends \
    meson libwayland-dev wayland-protocols libpango1.0-dev libdbus-1-dev \
 && git clone --depth 1 https://gitlab.gnome.org/jadahl/libdecor.git --branch $libdecor_ver \
 && cd libdecor \
 && meson build --buildtype release -D demo=false -D prefix=/usr/ \
 && DESTDIR=stage meson install -C build \
 && apt clean

##

FROM weitjong/dockerized:urho3d-base

RUN dpkg --add-architecture i386 && apt update && apt upgrade -y && apt install -y --no-install-recommends \
    # Display server
    libgl1-mesa-dev libxcursor-dev libxi-dev libxinerama-dev libxrandr-dev libxrender-dev libxss-dev libxxf86vm-dev \
    libwayland-dev libxkbcommon-dev wayland-protocols wayland-scanner++ \

    # Sound server
    libasound2-dev libpulse-dev \
    libpipewire-0.3-dev \

    # IME
    libibus-1.0-dev \

    # Misc.
    libdbus-1-dev libreadline6-dev libssl-dev libudev-dev \

    # LLVM/Clang compiler toolchain, use 'CC=clang CXX=clang++' to choose this toolchain instead of gcc/g++
    clang clang-tidy clang-format \

    # Virtual framebuffer for CI testing
    xvfb \

    # 32-bit support, use 'ARCH=32bit' or 'ARCH=32' to do 32-bit build
    pkg-config-i686-linux-gnu \
    libgl1-mesa-dev:i386 libxcursor-dev:i386 libxi-dev:i386 libxinerama-dev:i386 libxrandr-dev:i386 libxrender-dev:i386 libxss-dev:i386 libxxf86vm-dev:i386 \
    libwayland-dev:i386 libxkbcommon-dev:i386 \
    libasound2-dev:i386 libpulse-dev:i386 \
    libibus-1.0-dev:i386 \
    libdbus-1-dev:i386 libreadline6-dev:i386 libssl-dev:i386 libudev-dev:i386 \

    # Comment out for now as Ubuntu does not have it yet
    #libpipewire-0.3-dev:i386 \

    # Clean up
 && apt clean

COPY --from=libdecor-builder /libdecor/build/stage/ /
COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/linux_entrypoint.sh"]

CMD ["/usr/bin/rake"]

# vi: set ts=4 sw=4 expandtab:
