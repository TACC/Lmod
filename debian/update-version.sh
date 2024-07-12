#!/bin/bash
set -e

cd "$(dirname "$(realpath "$0")")" # go to the directory where this script exists

git fetch --tags
latest_tag="$(git rev-list --tags --max-count=1)"
latest_version="$(git describe --tags "$latest_tag")"
echo "Version is $latest_version"

if head -n1 ./changelog | grep $latest_version; then
   echo "Latest version already in deb changelog. I should not do a thing"
   exit 0
fi

echo "It's not the latest version. Adding a new tag to changelog"

### Adding a new changelog entry. Yes, I use ex

ex ./changelog <<EOM
1 insert
lmod ($latest_version) unstable; urgency=medium

  * Setting TAG_VERSION to $latest_version

 -- Lmod automatic deb version script <fake.email@tacc.org>  $(date -R)


.
xit
EOM

### Adding the filenames to debian/files with correct version

cat >./files <<EOM
lmod_${latest_version}_all.deb devel optional
lmod_${latest_version}_amd64.buildinfo devel optional
EOM
