#! /bin/bash -e

# Don't source this file or this line won't work.
dockerfile="$(dirname "$0")/Dockerfile"

get_versions () {
    # name=$1, json_file=$2
    curl --show-error --silent --location --header 'Accept: application/json' "https://hackage.haskell.org/package/${1}/preferred" > "$2"
}

extract_latest_version () {
    # json_file=$1, version_file=$2
    jq --raw-output '.["normal-version"] | .[0]' "$1" > "$2"
}

edit_dockerfile () {
    # name=$1, version=$2
    sed --regexp-extended --in-place "s/$1-[0-9\.]+/$1-$2/" "$dockerfile"
}

update_package () {
    package_name=$1
    temp_dir=$2
    _prefix="${temp_dir}/${package_name}"
    json_file="${_prefix}.json"
    version_file="${_prefix}.version"

    get_versions "$package_name" "$json_file"
    extract_latest_version "$json_file" "$version_file"

    # Don't use cat when not needed
    version=$(< "$version_file")

    edit_dockerfile "$package_name" "$version"
}

echoerr () {
    echo "$@" 1>&2
}

log () {
    echoerr "$@"
}

execute () {
    log "Creating tempdir"
    _tempdir=$(mktemp --directory)
    log "Backing up Dockerfile for diffing"
    cp "$dockerfile" "${dockerfile}.bak"
    log "Updating hlint"
    update_package hlint "$_tempdir"
    log "Updating fourmolu"
    update_package fourmolu "$_tempdir"
    log "Updating cabal-fmt"
    update_package cabal-fmt "$_tempdir"
    log "Updating packdeps"
    update_package packdeps "$_tempdir"
    log "Updating hadolint"
    update_package hadolint "$_tempdir"
    # We don't care about the exit code, we just want the diff output
    log "Running diff to check for changes"
    diff "${dockerfile}.bak" "$dockerfile" || true
    log "Cleaning up temp files"
    rm --recursive --force "$_tempdir"
    log "Done."
}

execute
