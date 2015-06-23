FROM debian:jessie
MAINTAINER Werner Beroux <werner@beroux.com>

RUN apt-get update \
    && apt-get install -y \
        git \
        build-essential \
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PHANTOM_JS_TAG 2.0.0

RUN git clone https://github.com/ariya/phantomjs.git /tmp/phantomjs && \
  cd /tmp/phantomjs && git checkout $PHANTOM_JS_TAG && \
  ./build.sh --confirm && mv bin/phantomjs /usr/local/bin && \
  rm -rf /tmp/phantomjs

# Run as non-root user
RUN useradd --system --uid 72379 -m --shell /usr/sbin/nologin phantomjs
USER phantomjs

EXPOSE 8910

CMD ["/usr/local/bin/phantomjs"]
