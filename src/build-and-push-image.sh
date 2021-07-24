#! /bin/bash -e

dockerfile="$(dirname "$0")/Dockerfile"

IMAGE_NAME=haskell-dev-tools
IMAGE_VERSION=8.10.4
IMAGE_HOST=ghcr.io
IMAGE_REPO=fossas

IMAGE_TAG="${IMAGE_NAME}:${IMAGE_VERSION}"
IMAGE_URL="${IMAGE_HOST}/${IMAGE_REPO}/${IMAGE_TAG}"

check_gh_token () {
    if [[ -z "$GITHUB_TOKEN" ]]; then
        echo "No GITHUB_TOKEN found" 1>&2
    fi
}

build_image () {
    # Build with no docker context, we don't need one.
    docker build --tag $IMAGE_TAG - < "$dockerfile"
}

do_login () {
    echo "$GITHUB_TOKEN" | docker login ghcr.io -u fossabot --password-stdin
}

push_image () {
    docker image tag $IMAGE_TAG $IMAGE_URL
    docker push $IMAGE_URL
}

check_gh_token
build_image
do_login
push_image
