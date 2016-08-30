FROM scratch

# this rootfs file is should be built by 'build-alpine-rootfs.sh' under this folder
ADD ./rootfs.tar.xz /

RUN apk update && \
    apk upgrade && \
    apk add --update \
        ca-certificates \
        curl && \
    rm -rf /var/cache/apk/*
