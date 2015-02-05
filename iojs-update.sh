#!/bin/bash

echo "> Getting latest version number"

VERSION=v${1:-$(curl https://iojs.org/dist/index.json | sed -e 's/^.*"version":"\([^"]*\)".*$/\1/' | head -n 2 | tail -n -1 | cut -c 2-)}
IOJS=iojs-${VERSION}-linux-x64
echo "> Downloading $VERSION of iojs"
curl -s https://iojs.org/dist/${VERSION}/${IOJS}.tar.xz | tar xvfJ -

echo "> Setting ownership of /usr/local to $USER"
sudo chown -R ${USER}:${USER} /usr/local

echo "> Moving extracted iojs binaries"
rm -rf /usr/local/lib/${IOJS} && mv ${IOJS} /usr/local/lib

echo "> Symlinks"
sudo rm -f /usr/local/bin/{iojs,node,npm,node-gyp}
ln -s /usr/local/lib/${IOJS}/bin/iojs /usr/local/bin/iojs
ln -s /usr/local/lib/${IOJS}/bin/node /usr/local/bin/node
ln -s /usr/local/lib/${IOJS}/bin/npm /usr/local/bin/npm

echo "iojs version: $(iojs -v), npm version: $(npm -v)"

