FROM alpine:3.12

# Install runtime dependencies.
RUN apk add --no-cache \
        bzip2 \
        ca-certificates \
        curl \
        dumb-init \
        fontconfig \
        libstdc++ \
        qt5-qtwebkit

RUN apk add --no-cache -t .deps \
        cmake \
        g++ \
        git \
        make \
        qt5-qttools-dev \
        qt5-qtwebkit-dev \
    # Build PhantomJs from source code.
    # https://github.com/ariya/phantomjs/blob/master/INSTALL
 && git clone --recurse-submodules https://github.com/ariya/phantomjs /tmp/phantomjs \
 && cd /tmp/phantomjs \
 && ./configure \
 && make \
 && make install \
    # Clean-up.
 && apk del --purge .deps \
 && rm -rf /tmp/*

# https://github.com/sgerrand/alpine-pkg-glibc
ARG GLIBC_VERSION=2.31-r0

RUN set -x \
    # Installs GLIBC.
    # TODO: Check if this is required.
 && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk \
 && apk add glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk \
 && rm glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk \
 && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8

# Avoids warning message (can be any writable directory).
ENV XDG_RUNTIME_DIR=/tmp/runtime-phantomjs

# Run as non-root user
RUN adduser -S -D -H -u 72379 -s /usr/sbin/nologin phantomjs
USER phantomjs

# Quick sanity check.
RUN phantomjs --version

EXPOSE 8910

ENTRYPOINT ["dumb-init"]
CMD ["phantomjs"]

# NOTE: The healthcheck only makes sense if it's started with --webdriver=8910
#HEALTHCHECK --interval=5s --timeout=2s --retries=20 \
#    CMD curl --connect-timeout 5 --silent --show-error --fail http://localhost:8910/wd/hub/status || exit 1
