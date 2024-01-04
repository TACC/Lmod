#!/bin/bash

# update master branch, just to keep it up with upstream
git checkout debian
git pull upstream master 
git push

# Get latest tags from upstream. Github UI is not enough
git fetch upstream --tags 
git push --tags

VERSION=$(git describe --tags `git rev-list --tags --max-count=1`)
echo "Version is $VERSION"

if head -n1 ../debian/changelog | grep $VERSION ; then
   echo "Latest version. I should not do a thing"
else
   echo "It's not the latest version. Adding a new tag to changelog"

### Adding a new changelog entry. Yes, I use ex

   ex ../debian/changelog << EOM
1 insert
lmod ($VERSION) unstable; urgency=medium

  * Setting TAG_VERSION to $VERSION

 -- Alexandre Strube <surak@surak.eti.br>  $(date -R)


.
xit
EOM

### Adding the filenames to debian/files with correct version

   cat > ../debian/files << EOM
lmod_${VERSION}_all.deb devel optional
lmod_${VERSION}_amd64.buildinfo devel optional
EOM

### Adding right version to dockerfile . The '' is because of the bsd version of sed.
sed -i '' "s/git checkout tags.*/git checkout tags\/$VERSION \; \\\ /g" Dockerfile
sed -i '' "s/lmod_.*/lmod_${VERSION}_all.deb ; \\\ /g" Dockerfile 

### The container will fetch those from github, so they better be updated
git add ../debian/files ../debian/changelog Dockerfile
git commit -m "Added tag ${VERSION}" 
git push

# Build a docker image, calling Dockerfile from here. It clones this repo, checks out 
# the latest tag, builds the debian package inside, creates a container from such
# image, copies the file out and deletes the container (not the image)
docker build -t debian .
docker create --name deb debian 
docker cp deb:/tmp/git-repo/lmod_${VERSION}_all.deb .
docker rm deb

echo "To run this image: docker run --rm -it --name deb debian  /bin/bash \nTo cleanup the cache: docker builder prune -a -f "
fi
