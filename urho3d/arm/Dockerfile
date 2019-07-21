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

ARG tool_version=5.5.0-2017.10-x86_64
ARG armhf_triplet=arm-linux-gnueabihf
ARG arm64_triplet=aarch64-linux-gnu

ENV ARMHF_PREFIX=/gcc-linaro-${tool_version}_$armhf_triplet/bin/$armhf_triplet \
    ARM64_PREFIX=/gcc-linaro-${tool_version}_$arm64_triplet/bin/$arm64_triplet \
    ARMHF_SYSROOT=/armhf-sysroot \
    ARM64_SYSROOT=/arm64-sysroot

RUN for triplet in $armhf_triplet $arm64_triplet; do tool=gcc-linaro-${tool_version}_$triplet \
    && wget -q https://releases.linaro.org/components/toolchain/binaries/latest-5/$triplet/$tool.tar.xz -O /tmp/$tool.tar.xz \
    && tar -C / -xof /tmp/$tool.tar.xz && rm /tmp/$tool.tar.xz; done \
    && for sysroot in $ARMHF_SYSROOT $ARM64_SYSROOT; do git clone -q --depth 1 https://github.com/urho3d$sysroot.git $sysroot; done

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/arm_entrypoint.sh"]

CMD rake cmake arm && rake make arm

# vi: set ts=4 sw=4 expandtab:
