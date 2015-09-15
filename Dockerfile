FROM debian:jessie
MAINTAINER Werner Beroux <werner@beroux.com>

# 1. Install compile and runtime dependencies
# 2. Compile PhantomJS from the source code
# 3. Remove compile depdencies
# We do all in a single commit to reduce the image size (a lot!)
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        curl \
        g++ \
        flex \
        bison \
        gperf \
        ruby \
        perl \
        python \
        libsqlite3-dev \
        libfontconfig1-dev \
        libicu-dev \
        libfreetype6 \
        libssl-dev \
        libpng-dev \
        libjpeg-dev \
        libqt5webkit5-dev \
    && curl -L https://github.com/ariya/phantomjs/archive/2.0.0.tar.gz | tar -xzC /tmp \
    && cd /tmp/phantomjs-2.0.0 \
    && ./build.sh --confirm --silent --jobs 2 \
    && mv bin/phantomjs /usr/local/bin \
    && cd \
    && apt-get purge --auto-remove -y \
        build-essential \
        curl \
        g++ \
        flex \
        bison \
        gperf \
        ruby \
        perl \
        python \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*

# Run as non-root user
RUN useradd --system --uid 72379 -m --shell /usr/sbin/nologin phantomjs
USER phantomjs

EXPOSE 8910

CMD ["/usr/local/bin/phantomjs"]
