#!/bin/bash

set -e -o pipefail

version=2.2.4

apt-get -y install build-essential pkg-config libunistring-dev libffi-dev libgc-dev libgmp-dev libltdl-dev libreadline-dev libncurses5-dev 

cd /tmp
wget https://ftp.gnu.org/gnu/guile/guile-${version}.tar.gz
cat guile-${version}.tar.gz | gunzip | tar x
cd guile-${version}
./configure --prefix=/opt/guile-${version}
nice make
make install
ln -sf /opt/guile-${version}/bin/guile /usr/local/bin/guile
