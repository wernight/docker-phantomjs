FROM debian:buster-slim

ARG PHANTOM_JS_VERSION
ARG DUMB_INIT_VERSION

# https://bitbucket.org/ariya/phantomjs/downloads/
ENV PHANTOM_JS_VERSION ${PHANTOM_JS_VERSION:-2.1.1-linux-x86_64}

# Install runtime dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        bzip2 \
        libfontconfig \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# https://github.com/Yelp/dumb-init/releases
ENV DUMB_INIT_VERSION ${DUMB_INIT_VERSION:-1.2.2}

RUN set -x  \
    # Install official PhantomJS release
 && mkdir /tmp/phantomjs \
 && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOM_JS_VERSION}.tar.bz2 \
        | tar -xj --strip-components=1 -C /tmp/phantomjs \
 && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
    # Install dumb-init (to handle PID 1 correctly).
 && curl -Lo /tmp/dumb-init.deb https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64.deb \
 && dpkg -i /tmp/dumb-init.deb

# PhantomJS requires  an OpenSSL config even if it's an empty one,
# else it'll complain about "libssl_conf.so: cannot open shared object file"
# which seems to be a recent bug.
ENV OPENSSL_CONF=/opt/openssl.cnf

RUN set -x \
    # Runs as non-root user.
 && useradd --system --uid 52379 -m --shell /usr/sbin/nologin phantomjs \
 && touch /opt/openssl.cnf \
    # Basic test.
 && su phantomjs -s /bin/sh -c "dumb-init phantomjs --version"

USER phantomjs

EXPOSE 8910

ENTRYPOINT ["dumb-init"]
CMD ["phantomjs"]

# NOTE: The healthcheck only makes sense if it's started with --webdriver=8910
#HEALTHCHECK --interval=5s --timeout=2s --retries=20 \
#    CMD curl --connect-timeout 5 --silent --show-error --fail http://localhost:8910/wd/hub/status || exit 1
