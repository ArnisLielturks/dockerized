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

FROM ubuntu:latest

LABEL description="Dockerized build environment for Urho3D" \
      source-repo=https://github.com/urho3d/dockerized \
      binary-repo=https://hub.docker.com/u/urho3d

ARG lang=en_US.UTF-8
ARG cmake_version=3.14.5

ENV USE_CCACHE=1 CCACHE_SLOPPINESS=pch_defines,time_macros CCACHE_COMPRESS=1 \
    URHO3D_LUAJIT=1 \
    HOST_UID=1000 HOST_GID=1000

RUN apt-get update && apt-get install -y \
    # Essential
    build-essential ccache git g++-multilib \
    \
    # Documentation
    doxygen graphviz locales \
    \
    # Misc.
    rake rsync sudo vim wget \
    \
    # Download CMake directly from its provider
    && wget -qO- https://github.com/Kitware/CMake/releases/download/v$cmake_version/cmake-$cmake_version-Linux-x86_64.tar.gz |tar --strip-components=1 -xz -C /usr/local \
    \
    # Setup default locale
    && locale-gen $lang && update-locale LANG=$lang

VOLUME /home/urho3d

COPY sysroot/ /

ENTRYPOINT ["/script_dir/entrypoint.sh"]

CMD ["/bin/bash"]

# vi: set ts=4 sw=4 expandtab:
