#!/usr/bin/env bash

# based on https://github.com/luxas/alpine-arm/blob/master/rootfs/mkimage.sh

tmp() {
    TMP=$(mktemp -d /tmp/alpine-docker-XXXXXXXXXX)
    ROOTFS=$(mktemp -d /tmp/alpine-docker-rootfs-XXXXXXXXXX)
    trap "rm -rf $TMP $ROOTFS" EXIT TERM INT
}

apkv() {
    set -x
    curl -s $REPO/$ARCH/APKINDEX.tar.gz | tar -Oxz |
        grep '^P:apk-tools-static$' -a -A1 | tail -n1 | cut -d: -f2
}

getapk() {
    curl -s $REPO/$ARCH/apk-tools-static-$(apkv).apk |
        tar -xz -C $TMP sbin/apk.static
}

mkbase() {
    $TMP/sbin/apk.static --repository $REPO --update-cache --allow-untrusted \
                         --root $ROOTFS --initdb add alpine-base
}

confrepo() {
    printf '%s\n' $REPO > $ROOTFS/etc/apk/repositories
}

save() {
    tar --numeric-owner -C $ROOTFS -c . | xz > /srv/rootfs.tar.xz
}

REL=${REL:-edge}
MIRROR=${MIRROR:-http://nl.alpinelinux.org/alpine}
REPO=$MIRROR/$REL/main

# $1 - architecture to be built of the rootfs file
ARCH=${1:-aarch64}

# main
tmp && getapk && mkbase && confrepo && save
