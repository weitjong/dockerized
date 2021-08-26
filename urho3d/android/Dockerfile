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

FROM weitjong/dockerized:urho3d-base

ARG tool_url=https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
ARG tool_version=31.0.0
ARG ndk_version=23.0.7599858
ARG platform=31

ENV PLATFORM=android \
    ANDROID_HOME=/android-sdk ANDROID_CCACHE=/usr/bin/ccache

RUN apt update && apt upgrade -y && apt install -y --no-install-recommends openjdk-11-jdk-headless \
 && mkdir -p $ANDROID_HOME/cmdline-tools && cd $ANDROID_HOME/cmdline-tools && wget -qO- $tool_url |jar x \
 && echo 'y' |bash cmdline-tools/bin/sdkmanager \
        "build-tools;$tool_version"\
        "ndk;$ndk_version" \
        'platform-tools' \
        'cmdline-tools;latest' \
        "platforms;android-$platform" \
        # Hack quiet mode for sdkmanager
        |grep -v '\[.*\]' \
 && rm -rf cmdline-tools \
 && apt clean

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/android_entrypoint.sh"]

CMD ["/usr/bin/rake"]

# vi: set ts=4 sw=4 expandtab:
