#!/bin/bash

version=2.49

set -e -o pipefail

if [ "$USER" != "root" ]
then
    echo "Error: this script must be run as root." > &2
    exit 1
fi

apt-get install build-essential libffcall1-dev libsigsegv-dev libreadline-dev

# the build fails on my mini10v, asking me to add -falign-functions=4 to CFLAGS.
if [ "`uname -m`" == "i686" ]; then
    export CFLAGS=-falign-functions=4
fi

cd /tmp
wget http://ftp.gnu.org/pub/gnu/clisp/release/${version}/clisp-${version}.tar.gz
cat clisp-${version}.tar.gz | gunzip | tar x
cd clisp-${version}
./configure --prefix=/opt/clisp-${version}
cd src
make
make install
ln -sf /opt/clisp-${version}/bin/clisp /usr/local/bin/
