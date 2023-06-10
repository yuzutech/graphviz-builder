FROM eclipse-temurin:11.0.18_10-jre-jammy

ARG GRAPHVIZ_VERSION=8.0.4

RUN apt-get update && apt-get install --no-install-recommends --yes \
    libcairo2 \
    libgd-dev \
    zlib1g-dev \
    libpangoft2-1.0-0 \
    build-essential \
    g++-11 \
    libgvc6 \
    libjpeg9 \
    giflib-tools \
    fonts-freefont-ttf \
    fonts-noto-cjk \
    ghostscript

RUN wget https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/${GRAPHVIZ_VERSION}/graphviz-${GRAPHVIZ_VERSION}.tar.gz -O graphviz.tar.gz && \
    mkdir -p graphviz-src && \
    tar xvzf graphviz.tar.gz --strip-components=1 -C graphviz-src && \
    cd graphviz-src && \
    ./configure \
      --prefix=/usr \
      --sysconfdir=/etc \
      --disable-python \
      --disable-silent-rules \
      --disable-dependency-tracking \
      --disable-ltdl-install \
      --enable-static=yes \
      --enable-shared=no \
      --enable-ltdl \
      --enable-sharp=no \
      --enable-go=no \
      --enable-guile=no \
      --enable-java=no \
      --enable-lua=yes \
      --enable-ocaml=no \
      --enable-perl=no \
      --enable-php=no \
      --enable-python3=no \
      --enable-r=no \
      --enable-ruby=no \
      --enable-tcl=no \
      --without-included-ltdl \
      --with-gdk-pixbuf=yes \
      --with-ipsepcola=yes \
      --with-jpeg \
      --with-libgd=yes \
      --with-pangocairo=yes \
      --with-rsvg=yes \
      --with-x && \
    make && make install \

RUN graphviz-src/cmd/dot/dot_static -V && \
    echo "digraph G {Hello->World}" | graphviz-src/cmd/dot/dot_static -Tpng > hello.png && \
    echo "digraph G {Hello->World}" | graphviz-src/cmd/dot/dot_static -jpeg > hello.jpeg && \
    echo "digraph G {Hello->World}" | graphviz-src/cmd/dot/dot_static -Tsvg > hello.svg && \
    echo "digraph G {Hello->World}" | graphviz-src/cmd/dot/dot_static -Tpdf > hello.pdf
