#!/usr/bin/env bash
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

# Select the compiler toolchain based on the URHO3D_64BIT env var
if [[ "$URHO3D_64BIT" == "0" ]]; then
    export MINGW_PREFIX=/usr/bin/i686-w64-mingw32 \
           DIRECTX_INC_SEARCH_PATHS=/usr/i686-w64-mingw32/include \
           DIRECTX_LIB_SEARCH_PATHS=/usr/i686-w64-mingw32/lib
else
    export MINGW_PREFIX=/usr/bin/x86_64-w64-mingw32 \
           DIRECTX_INC_SEARCH_PATHS=/usr/x86_64-w64-mingw32/include \
           DIRECTX_LIB_SEARCH_PATHS=/usr/x86_64-w64-mingw32/lib
fi

# Execute the command chain
exec "$@"

# vi: set ts=4 sw=4 expandtab:
