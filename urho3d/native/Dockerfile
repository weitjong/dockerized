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

FROM urho3d/dockerized:latest

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --no-install-recommends \
    # Display server
    libgl1-mesa-dev libxcursor-dev libxi-dev libxinerama-dev libxrandr-dev libxrender-dev libxss-dev libxxf86vm-dev \
    \
    # Sound server
    libasound2-dev libpulse-dev \
    \
    # IME
    libibus-1.0-dev \
    \
    # Misc.
    libdbus-1-dev libreadline6-dev libssl-dev libudev-dev \
    \
    # LLVM/Clang compiler toolchain, use 'CC=clang CXX=clang++' to choose this toolchain instead of gcc/g++
    clang clang-tidy clang-format \
    \
    # 32-bit support, use 'URHO3D_64BIT=0' to do 32-bit build
    libxrandr-dev:i386 libglapi-mesa:i386 libgl1-mesa-glx:i386 libgl1-mesa-dev:i386 libxext-dev:i386 \
    libxrender-dev:i386 libglib2.0-dev:i386 libdbus-1-dev:i386 lib32readline6-dev \
    \
    # Virtual framebuffer for CI testing
    xvfb

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/native_entrypoint.sh"]

CMD rake cmake && rake make

# vi: set ts=4 sw=4 expandtab:
