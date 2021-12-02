#!/bin/sh
set -e

# NPM will become available here later on in the main function
npm_path="$(pwd)/node_modules/.bin"

# NPM versions can be found at https://www.npmjs.com/package/npm
# We try to keep a reasonably modern version
npm_version="8.1.4"

# Path to the asset file
asset_file="web/ui/assets_vfsdata.go"

# Directory we clone upstream to.
clone_dir="prometheus"

# Upstream Prometheus repo
prometheus_repo="https://github.com/prometheus/prometheus.git"

# Shallow clones a single repository branch
clone() {
    local repo="$1"
    local branch="$2"
    local output_dir="$3"

    git clone \
        --depth=1 \
        --branch="${branch}" \
        --single-branch \
        "${repo}" \
        "${output_dir}"
}

# Heads into $dir and executes `gmake assets`
make_asset() {
    local dir="$1"

    ( \
        cd "${dir}" \
        && gmake assets \
    )
}

# Copy the asset from the clone dir to its correct location
copy_asset() {
    local dir="$1"

    cp -v \
        "${dir}/${asset_file}" \
        "${asset_file}"
}

# We need a much more up to date npm installing before we can continue with
# building the frontend.
# FreeBSD currently only has npm v6, which is too old and won't build things
# correctly.
install_npm() {
    local version="$1"

    npm install "npm@${version}"
}

# Entry point
main() {
    local version="$1"
    local output_dir="${clone_dir}-${version}"

    if [ -z "${version}" ]; then
        echo "Must provide a Prometheus version (tag or branch) to clone" >&2
        echo "Usage: $0 <VERSION>" >&2
        exit 1
    fi

    if ! echo "${version}" | grep --quiet "^v"; then
        echo "Prometheus versions must be prefixed with 'v', eg v${version}" >&2
        echo "Usage: $0 <VERSION>"
        exit 1
    fi

    if [ -d "${clone_dir}" ]; then
        echo "Clone directory '${clone_dir}' already exists, rm it to continue" >&2
        exit 1
    fi

    # Install the latest npm and add it to the PATH.
    install_npm "${npm_version}"
    export PATH="${npm_path}:${PATH}"

    clone "${prometheus_repo}" "${version}" "${output_dir}"
    make_asset "${output_dir}"
    copy_asset "${output_dir}"
}

main "$@"
