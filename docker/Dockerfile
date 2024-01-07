FROM debian:12

# Optionally, add incoming to sources.list
#RUN echo 'deb http://incoming.debian.org/debian-buildd buildd-unstable main contrib non-free' > /etc/apt/sources.list.d/incoming.list

# Add deb-src to sources.list
RUN find /etc/apt/sources.list* -type f -exec sed -i 'p; s/^deb /deb-src /' '{}' +

# Install developer tools
RUN apt-get update \
 && apt-get install --no-install-recommends -yV \
    apt-utils \
    build-essential \
    devscripts \
    equivs \
    devscripts \
    autoconf \
    automake \
    autopoint \
    autotools-dev \
    debhelper \
    dh-autoreconf \
    dh-strip-nondeterminism \
    dwz \
    libdebhelper-perl \
    libfile-stripnondeterminism-perl \
    libsub-override-perl \
    libtool \
    po-debconf \
    quilt \
    tcl-dev \
    liblua5.3-dev \
    git \
    nano \
    lua-filesystem \
    lua-json \
    lua-posix \
    lua-term \
    lua5.3 \
    procps \
    bc
    

RUN mkdir /tmp/git-repo; cd /tmp/git-repo ; \
    git clone https://github.com/surak/Lmod.git ; \
    cd Lmod ; \
    git fetch --tags; \
    git checkout tags/8.7.34 ; \ 
    git checkout origin/debian debian docker ; \
    cd Lmod ; debuild -b -uc -us; \
    cd .. ; dpkg -i ./lmod_8.7.34_all.deb ; \ 
    bash -c "source /etc/profile.d/lmod.sh; module --version"

