#! /bin/bash -ex

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

execute () {
    _tempdir=$(mktemp --directory)
    cp "$dockerfile" "${dockerfile}.bak"
    update_package hlint "$_tempdir"
    update_package fourmolu "$_tempdir"
    diff "${dockerfile}.bak" "$dockerfile"
    rm --recursive --force "$_tempdir"
}

execute