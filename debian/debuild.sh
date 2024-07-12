#!/bin/bash
set -e

image_name="debuild-image"
ct_name="lmod-debuild"
repo_dir="$(dirname "$(dirname "$(realpath "$0")")")"
dockerfile_path="$(mktemp)"
output_dir_path="$(mktemp -d)"

cat >"$dockerfile_path" <<'EOF'
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
    bc

# recursive copy all files into container. Bind mount can cause unwanted changes in cwd.
COPY . /lmod/src
# install dependencies from the debian control file
RUN mk-build-deps --install --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' /lmod/src/debian/control

EOF

cd "$repo_dir" # required for relative path inside dockerfile
docker build . --tag="$image_name" --file="$dockerfile_path"
docker run --name="$ct_name" --workdir="/lmod/src" "$image_name" debuild -us -uc -b
docker cp "$ct_name:/lmod/" "$output_dir_path/"
docker rm "$ct_name"
echo "output files have been copied to \"$output_dir_path\"."
