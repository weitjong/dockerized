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

FROM urho3d/dockerized:latest

ARG tool_url=https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip
ARG tool_version=29.0.2
ARG ndk_version=21.3.6528147
ARG platforms=18,21,30

ENV PLATFORM=android \
    ANDROID_HOME=/android-sdk ANDROID_CCACHE=/usr/bin/ccache

RUN apt-get update && apt-get install -y --no-install-recommends openjdk-8-jdk ninja-build \
    \
    # Download Android SDK command line tools only
 && mkdir -p $ANDROID_HOME/cmdline-tools && cd $ANDROID_HOME/cmdline-tools && wget -qO- $tool_url |jar x \
    \
    # Fix missing configuration file
 && mkdir /root/.android && touch /root/.android/repositories.cfg \
    \
    # Install Android NDK and other build tools, excluding CMake
 && (while :; do echo 'y'; sleep 1; done) |bash $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager \
        "build-tools;$tool_version"\
        "ndk;$ndk_version" \
        'platform-tools' \
        $(bash -c "echo platforms\;android-{$platforms}") \
        # Hack quiet mode for sdkmanager
        |grep -v '\[.*\]' \
    \
    # Strip-off some bits to reduce layer/image size
 && find $ANDROID_HOME/ndk/$ndk_version/platforms -mindepth 1 -maxdepth 1 \
       |grep -Ev "\-($(bash -c 'echo ${platforms//,/\|}'))$" |xargs rm -rf \
    \
    # Clean up
 && apt-get clean

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/android_entrypoint.sh"]

CMD ["/usr/bin/rake"]

# vi: set ts=4 sw=4 expandtab:
