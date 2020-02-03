#!/bin/bash
set -e -o pipefail -x

apt-get update
apt-get install -y locales
locale-gen en_US.UTF-8

apt-get install -y wget default-jdk curl

dist=$HOME/dist
mkdir -p $dist

# install clojure
version=1.10.1.507
if [ ! -e /usr/local/bin/clojure ] ; then
    if [ ! -e $dist/linux-install-$version.sh ] ; then
        cd $dist
        curl -O https://download.clojure.org/install/linux-install-$version.sh
    fi
    bash $dist/linux-install-$version.sh
fi

# build planck
version=2.24.0
apt-get install -y build-essential cmake pkg-config unzip xxd
apt-get install -y libjavascriptcoregtk-4.0 libglib2.0-dev libzip-dev libcurl4-gnutls-dev libicu-dev
if [ ! -e $dist/planck-$version.tar.gz ] ; then
    cd $dist
    wget -O planck-$version.tar.gz https://github.com/planck-repl/planck/archive/$version.tar.gz
fi
mkdir -p $HOME/tmp
cd $HOME/tmp
if [ ! -e planck-$version ] ; then
    cat $dist/planck-$version.tar.gz | gunzip | tar x
fi
cd planck-$version
script/build --verbose
script/test || true

# install planck
script/install -p /opt/planck-$version
ln -sf /opt/planck-$version/bin/planck /usr/local/bin/
ln -sf /opt/planck-$version/bin/plk /usr/local/bin/
ln -sf /opt/planck-$version/share/man/man1/planck.1 /usr/local/share/man/man1/
ln -sf /opt/planck-$version/share/man/man1/plk.1 /usr/local/share/man/man1/

# package planck
cd /opt
tar c planck-$version | gzip > $HOME/tmp/planck-$version-buster-i386.tar.gz

exit 0
