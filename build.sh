#!/usr/bin/bash

rm -rf buildroot/
[ -d tiled ] || git clone https://github.com/bjorn/tiled.git
[ -d buildroot ] || mkdir -p buildroot/{SOURCES,SPECS}

BRANCH=$(git rev-parse --abbrev-ref HEAD)
pushd tiled
    git fetch
    git reset --hard origin/$BRANCH
    VERSION=$(git describe | sed 's/^v//' | sed 's/-[^-]*$//' | sed 's/-/\./')
    git archive HEAD --prefix=tiled-$VERSION/ -o ../buildroot/SOURCES/tiled-$VERSION.tar.gz
popd

cat tiled.spec | sed "s/^Version:\(.*\)/Version: $VERSION/" > buildroot/SPECS/tiled_tmp.spec
rpmbuild --define "_topdir ${PWD}/buildroot/" -bs buildroot/SPECS/tiled_tmp.spec

pushd buildroot
    FILE=$(find -name "*.src.rpm")
    cp $FILE ../tiled.src.rpm
popd


