#!/usr/bin/env bash
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

# Select the compiler toolchain based on the ARCH env var
if [[ "${ARCH/bit}" == "32" ]]; then
    export ARM_PREFIX=$ARM32_PREFIX ARM_SYSROOT=$ARM32_SYSROOT
else
    export ARM_PREFIX=$ARM64_PREFIX ARM_SYSROOT=$ARM64_SYSROOT
fi

# Custom ccache symlinks update
sudo bash -c "cd /usr/lib/ccache \
    && ln -s ../../bin/ccache ${ARM_PREFIX##*/}-gcc \
    && ln -s ../../bin/ccache ${ARM_PREFIX##*/}-g++"

# Append path to the selected toolchain
PATH=$PATH:${ARM_PREFIX%/*}

# Execute the command chain
exec "$@"

# vi: set ts=4 sw=4 expandtab:
