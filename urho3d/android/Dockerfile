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

ARG tool_url=https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
ARG tool_version=28.0.3
ARG platforms=17,21,28

ENV ANDROID_HOME=/android-sdk ANDROID_CCACHE=/usr/bin/ccache

RUN apt-get update && apt-get install -y --no-install-recommends openjdk-8-jdk ninja-build wget unzip \
    \
    # Download Android SDK command line tools only
    && mkdir $ANDROID_HOME && cd $ANDROID_HOME && wget -qO- $tool_url |jar x \
    \
    # Fix missing configuration file
    && mkdir /root/.android && touch /root/.android/repositories.cfg \
    \
    # Install Android NDK and other build tools, excluding CMake
    && (while :; do echo 'y'; sleep 1; done) |bash $ANDROID_HOME/tools/bin/sdkmanager \
        "build-tools;$tool_version"\
        'ndk-bundle' \
        'platform-tools' \
        $(bash -c "echo platforms\;android-{$platforms}") \
        # Hack quiet mode for sdkmanager
        |grep -v '\[.*\]' \
    \
    # Strip-off some bits to reduce layer/image size
    && find $ANDROID_HOME -type f -name NOTICE\* |xargs rm \
    && find $ANDROID_HOME -type d -name renderscript |xargs rm -rf \
    && find $ANDROID_HOME/ndk-bundle/platforms -mindepth 1 -maxdepth 1 \
       |grep -Ev "\-($(bash -c 'echo ${platforms//,/\|}'))$" |xargs rm -rf \
    && cd $ANDROID_HOME/ndk-bundle && rm -rf sources/third_party \
        wrap.sh prebuilt python-packages shader-tools simpleperf ndk*

    # Download and set up OpenSSL
RUN wget https://github.com/leenjewel/openssl_for_ios_and_android/releases/download/android_openssl-1.1.1a/only_android_openssl-1.1.1a.zip \
    && unzip only_android_openssl-1.1.1a.zip -d /openssl \
    && export OPENSSL_SSL_LIBRARY=/openssl

COPY sysroot/ /

ENTRYPOINT ["/entrypoint.sh", "/android_entrypoint.sh"]

CMD ["./gradlew", "build"]

# vi: set ts=4 sw=4 expandtab:
