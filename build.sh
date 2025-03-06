#!/bin/bash

version=$1

_githubapi() {
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        curl -fsSL -H "Authorization: token $GITHUB_TOKEN" $1;
    else
        curl -fsSL $1;
    fi
}

if [ -z "$version"]; then
    echo "Version not specified, finding latest version"

    version="$(_githubapi 'https://api.github.com/repos/swiss-architecture-knife/swark/releases' | jq -r 'map(select(.tag_name | startswith ("v'$release'"))) | .[0].tag_name')"
fi

docker_directory=$(./find_root_directory.sh $version)

echo "Using version $version -> using Dockerfile in directory $docker_directory"

BUILD_DIRECTORY=build
mkdir $BUILD_DIRECTORY
cp -R shared/* $BUILD_DIRECTORY/
cp -R $docker_directory/* $BUILD_DIRECTORY/

cd $BUILD_DIRECTORY

for ext in tar.bz2 tar.bz2.sha512; do
    file=swark-${version}.$ext
    if [ ! -e "$file" ]; then
        echo "Downloading release $version/$file..."
        curl -fsSL -o swark-${version}.$ext "https://github.com/swiss-architecture-knife/swark/releases/download/${version}/$file"; 
    fi
done;

docker build -t swark/swark:${version} \
    --build-arg SWARK_VERSION=$version \
    --build-arg RELEASE_FILE=swark-${version}.tar.bz2 \
    .

docker tag swark/swark:${version} swark/swark:latest