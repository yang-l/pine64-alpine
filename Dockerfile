FROM scratch

ADD ./rootfs.tar.xz /

RUN apk update && \
    apk upgrade && \
    apk add --update \
        ca-certificates \
        curl && \
    rm -rf /var/cache/apk/*
