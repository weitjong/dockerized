#!/usr/bin/env bash
#
# Copyright (c) 2018-2022 Yao Wei Tjong. All rights reserved.
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

SAVED_EM_CACHE=$EM_CACHE

# Use the EMSDK provided script to setup the environment
source $EMSDK/emsdk_env.sh 2>/dev/null

# Restore the EM_CACHE as it has been wiped by EMSDK after 'source'
export EM_CACHE=$SAVED_EM_CACHE

# Copy the sysroot to $EM_CACHE on the docker volume, if it is not done yet
if [[ ! -d $EM_CACHE ]]; then
    sudo cp -rp $(cat $EM_CONFIG <(echo 'print(EMSCRIPTEN_ROOT)') |python -)/cache $EM_CACHE
fi

# Ensure ccache is being found first
PATH=/usr/lib/ccache:$PATH:$(cat $EM_CONFIG <(echo 'print(LLVM_ROOT)') |python -)

# Custom ccache symlinks update
sudo bash -c "cd /usr/lib/ccache \
    && ln -s ../../bin/ccache emcc \
    && ln -s ../../bin/ccache em++"

# Execute the command chain
exec "$@"

# vi: set ts=4 sw=4 expandtab:
