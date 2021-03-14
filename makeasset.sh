#!/bin/sh
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

    clone "${prometheus_repo}" "${version}" "${output_dir}"
    make_asset "${output_dir}"
    copy_asset "${output_dir}"
}

main "$@"
