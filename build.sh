#!/bin/bash

set -e
version=$1

_githubapi() {
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        curl -fsSL -H "Authorization: token $GITHUB_TOKEN" $1;
    else
        curl -fsSL $1;
    fi
}

if [ -z "$version" ]; then
    echo "Version not specified, finding latest version"

    version="$(_githubapi 'https://api.github.com/repos/swiss-architecture-knife/swark/releases' | jq -r 'map(select(.tag_name | startswith ("v'$release'"))) | .[0].tag_name')"
fi

# without beginning "v"
sanitized_version=${version/#v/}
# with "v"
release_version=v${sanitized_version}

docker_directory=$(./find_root_directory.sh $sanitized_version)

echo "Using version $version -> using Dockerfile in directory $docker_directory"

BUILD_DIRECTORY=build

if [ ! -e $BUILD_DIRECTORY ]; then
    mkdir $BUILD_DIRECTORY
fi

cp -R shared/* $BUILD_DIRECTORY/
cp -R $docker_directory/* $BUILD_DIRECTORY/

cd $BUILD_DIRECTORY

RELEASE_FILE="ERR_release_file_not_resolved"

for ext in tar.bz2 tar.bz2.sha512; do
    file=swark-${release_version}.$ext

    # .tar.bz is our release file to use
    if [ "tar.bz2" = "$ext" ]; then
        RELEASE_FILE=$file
    fi

    echo "Downloading release $release_version/$file..."

    if [ ! -e "$file" ]; then
        curl -fsSL -o $file "https://github.com/swiss-architecture-knife/swark/releases/download/${release_version}/$file"; 
    else 
        echo "... skipped download of $release_version/$file: already downloaded"
    fi
done

echo "Docker image build prepared"

if [ -v GITHUB_OUTPUT ]; then
    echo "build_directory=${BUILD_DIRECTORY}" >> "$GITHUB_OUTPUT"
    echo "release_file=${RELEASE_FILE}" >> "$GITHUB_OUTPUT"
    echo "release_version=${release_version}" >> "$GITHUB_OUTPUT"
    echo "sanitized_version=${sanitized_version}" >> "$GITHUB_OUTPUT"
else 
    echo "Not running on GitHub, no publishing of variables"
fi

if [ -v WITH_DOCKER_BUILD ]; then
    docker build -t swark/swark:${sanitized_version} \
        --build-arg SWARK_VERSION=$sanitized_version \
        --build-arg RELEASE_FILE=$RELEASE_FILE \
    .
fi

if [ -v WITH_DOCKER_PUSH ]; then
    docker tag \
        swark/swark:${sanitized_version} \
        swark/swark:${release_version}

    docker tag \
        swark/swark:${sanitized_version} \
        swark/swark:latest
fi
