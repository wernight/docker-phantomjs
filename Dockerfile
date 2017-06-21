FROM debian:stretch

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

    # Install QtWebKit.
    # https://github.com/annulen/webkit/wiki/Building-QtWebKit-on-Linux
 && git clone https://github.com/annulen/webkit.git /tmp/qtwebkit \
 && cd /tmp/qtwebkit \
 && WEBKIT_OUTPUTDIR=`pwd`/build/qt Tools/Scripts/build-webkit --qt --release --cmakeargs="-DCMAKE_PREFIX_PATH=~/Qt/5.7/gcc_64/" \
 && ninja install
 && export QMAKEPATH=

 && mkdir -p WebKitBuild/Release \
 && cd WebKitBuild/Release \
 && cmake -DPORT=Qt -DCMAKE_BUILD_TYPE=Release ../.. \
 #&& make -jN # Replace N with number of your CPU cores
 && make install

cmake \
ninja-build \
libfontconfig1-dev \
libicu-dev \
libsqlite3-dev \
zlib1g-dev \
libpng12-dev \
libjpeg-dev \
libxslt1-dev \
libxml2-dev \
libhyphen-dev \


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
        #qt5-default \
        ruby \
 && git clone --recurse-submodules https://github.com/ariya/phantomjs /tmp/phantomjs \
 && cd /tmp/phantomjs \
 && qmake
 && make
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
