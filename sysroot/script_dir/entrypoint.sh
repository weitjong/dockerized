#!/usr/bin/env bash
#
# Copyright (c) 2008-2018 the Urho3D project.
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

if [[ $1 == *bash ]]; then
    # Useful when executing 'bash' command
    sudo sed -i '/^#.*history-search/s/^# //' /etc/inputrc
else
    # Check if the project_dir/ is correctly mounted before proceeding further
    [[ -z $(ls -1 /project_dir) ]] && echo -e "Error: Container's '/project_dir' must be mounted from a project root on host filesystem.\n       See 'script/dockerized.sh' in the Urho3D project as use case sample." && exit 1
fi

# Delay updating the symlinks to runtime after all compiler toolchains have been installed
sudo /usr/sbin/update-ccache-symlinks

# Allow 'urho3d' user to write into mounted docker volumes
sudo chmod o+w /ccache_dir /home/urho3d

# Execute the command chain
exec "$@"
