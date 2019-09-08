## This file was forked from kevineye/docker-shairport-sync

FROM hypriot/rpi-alpine 

ARG SHAIRPORT_VERSION=$SHAIRPORT_VERSION

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
# && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk --update upgrade \
 && apk -U add \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        alsa-plugins-pulse \

 && cd /root \
 && git clone https://github.com/mikebrady/shairport-sync.git \
 && cd shairport-sync \

 && autoreconf -i -f \
 && ./configure \
        --with-alsa \
        --with-pipe \
        --with-avahi \
        --with-ssl=openssl \
        --with-soxr \
        --with-metadata \
 && make \
 && make install \

 && cd / \
 && apk --purge del \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
 && apk add \
        dbus \
        alsa-lib \
        libdaemon \
        popt \
        libressl \
        soxr \
        avahi \
        libconfig \
 && rm -rf \
        /etc/ssl \
        /var/cache/apk/* \
        /lib/apk/db/* \
        /root/shairport-sync

COPY start.sh /start

ENV AIRPLAY_NAME Docker

ENTRYPOINT [ "/start" ]
