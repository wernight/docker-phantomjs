FROM debian:jessie

# Install runtime dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        libsqlite3-dev \
        libfontconfig1-dev \
        libicu-dev \
        libfreetype6 \
        libssl-dev \
        libpng-dev \
        libjpeg-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        build-essential \
        g++ \
        git \
        flex \
        bison \
        gperf \
        perl \
        python \
        ruby \
 && git clone --recurse-submodules https://github.com/ariya/phantomjs /tmp/phantomjs \
 && cd /tmp/phantomjs \
 && ./build.py --release --confirm --silent >/dev/null \
 && mv bin/phantomjs /usr/local/bin \

    # Install dumb-init (to handle PID 1 correctly).
    # https://github.com/Yelp/dumb-init
 && curl -Lo /tmp/dumb-init.deb https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64.deb \
 && dpkg -i /tmp/dumb-init.deb \

    # Clean up
 && cd \
 && apt-get purge --auto-remove -y \
        build-essential \
        g++ \
        git \
        flex \
        bison \
        gperf \
        ruby \
        perl \
        python \
 && apt-get clean \
 && rm -rf /tmp/* /var/lib/apt/lists/*

    # Run as non-root user.
 && useradd --system --uid 72379 -m --shell /usr/sbin/nologin phantomjs \
 && su phantomjs -s /bin/sh -c "phantomjs --version"

USER phantomjs

EXPOSE 8910

ENTRYPOINT ["dumb-init"]
CMD ["phantomjs"]
