## Dockerfile for ar5ivist, using a fixed LaTeXML commit
##
## build with
##
## $ docker build --tag ar5ivist:latest .
##
## run with
##
## $ docker run -v "$(pwd)":/docdir -w /docdir \
##              --user "$(id -u):$(id -g)" \
##              ar5ivist:latest --source=main.tex --destination=html/main.html

FROM ubuntu:22.04

# Install the texlive toolchain first (v2021 in Ubuntu 22.04)
# as it largely stays constant in the background.
ENV DEBIAN_FRONTEND=noninteractive
RUN set -ex && apt-get update -qq && apt-get install -qy --no-install-recommends tzdata
RUN set -ex && apt-get update -qq && apt-get install -qy \
  texlive \
  texlive-fonts-extra \
  texlive-lang-all \
  texlive-latex-extra \
  texlive-bibtex-extra \
  texlive-science \
  texlive-pictures \
  texlive-pstricks \
  texlive-publishers

# latexml dependencies
RUN set -ex && apt-get update -qq && apt-get install -qy \
  build-essential \
  git \
  imagemagick \
  libarchive-zip-perl \
  libdb-dev \
  libfile-which-perl \
  libimage-magick-perl \
  libimage-size-perl \
  libio-string-perl \
  libjson-xs-perl \
  libparse-recdescent-perl \
  libtext-unidecode-perl \
  liburi-perl \
  libuuid-tiny-perl \
  libwww-perl \
  libxml-libxml-perl \
  libxml-libxslt-perl \
  libxml2 libxml2-dev \
  libxslt1-dev \
  libxslt1.1 \
  liblocal-lib-perl \
  make \
  perl-doc \
  cpanminus

# make sure perl paths are OK
RUN eval $(perl -I$HOME/perl5/lib -Mlocal::lib)
RUN echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"' >> ~/.bashrc

# Collect the extended arxmliv-bindings files
ENV ARXMLIV_BINDINGS_COMMIT=ccbd5f96bfb28d25ee2625dbb1c96eaa1f0ebb8e
RUN rm -rf /opt/arxmliv-bindings
RUN git clone https://github.com/dginev/arxmliv-bindings /opt/arxmliv-bindings
WORKDIR /opt/arxmliv-bindings
RUN git reset --hard $ARXMLIV_BINDINGS_COMMIT

# Install our local LaTeXML via cpanminus
RUN mkdir -p /opt/latexml
WORKDIR /opt/latexml

ADD . .
RUN cpanm --notest --verbose .

# Enable imagemagick policy permissions for work with arXiv PDF/EPS files
RUN perl -pi.bak -e 's/rights="none" pattern="([XE]?PS\d?|PDF)"/rights="read|write" pattern="$1"/g' /etc/ImageMagick-6/policy.xml
# Extend imagemagick resource allowance to be able to create with high-quality images
RUN perl -pi.bak -e 's/policy domain="resource" name="width" value="(\w+)"/policy domain="resource" name="width" value="126KP"/' /etc/ImageMagick-6/policy.xml
RUN perl -pi.bak -e 's/policy domain="resource" name="height" value="(\w+)"/policy domain="resource" name="height" value="126KP"/' /etc/ImageMagick-6/policy.xml
RUN perl -pi.bak -e 's/policy domain="resource" name="area" value="(\w+)"/policy domain="resource" name="area" value="2GiB"/' /etc/ImageMagick-6/policy.xml
RUN perl -pi.bak -e 's/policy domain="resource" name="disk" value="(\w+)"/policy domain="resource" name="disk" value="8GiB"/' /etc/ImageMagick-6/policy.xml
RUN perl -pi.bak -e 's/policy domain="resource" name="memory" value="(\w+)"/policy domain="resource" name="memory" value="2GiB"/' /etc/ImageMagick-6/policy.xml
RUN perl -pi.bak -e 's/policy domain="resource" name="map" value="(\w+)"/policy domain="resource" name="map" value="2GiB"/' /etc/ImageMagick-6/policy.xml

ENV MAGICK_DISK_LIMIT=2GiB
ENV MAGICK_MEMORY_LIMIT=512MiB
ENV MAGICK_MAP_LIMIT=1GiB
ENV MAGICK_TIME_LIMIT=900
ENV MAGICK_TMPDIR=/dev/shm
ENV TMPDIR=/dev/shm

# continue as instructed in https://www.howtogeek.com/devops/how-to-use-docker-to-package-cli-applications/
ENTRYPOINT ["/opt/latexml/bin/latexmlc", \
  "--preload=[nobibtex,ids,localrawstyles,mathlexemes,magnify=2,zoomout=2,tokenlimit=99999999,iflimit=1499999,absorblimit=1299999,pushbacklimit=599999]latexml.sty", \
  "--path=/opt/arxmliv-bindings/bindings", \
  "--path=/opt/arxmliv-bindings/supported_originals", \
  "--pmml","--cmml","--mathtex", \
  "--timeout=2700", \
  "--nodefaultresources","--css=https://cdn.jsdelivr.net/gh/dginev/ar5iv-css@0.7.4/css/ar5iv.min.css"]
CMD ["--source=main.tex", "--dest=main.html"]