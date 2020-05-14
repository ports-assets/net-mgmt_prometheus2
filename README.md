# `net-mgmt/prometheus2` assets

This repository contains pre-compiled assets for the [FreeBSD]
[`net-mgmt/prometheus2`] [Prometheus] port.
It is not possible to build these with the rest of the port, as [Yarn] requires
Internet access to download various dependencies.

There may be multiple tags pointing at the same commit in this repository if
the compiled assets do not change between Prometheus versions.

## Required Packages

The following packages are required to build the assets:

  - [`devel/gmake`]
  - [`lang/go`]
  - [`www/node10`]
  - [`www/yarn-node10`]

## Building the Assets

The assets are built as follows:

  - Check out the [Prometheus repository] and `cd` to the directory
  - Checkout the appropriate tag
    - eg. `git checkout v2.14.0`
  - Run `gmake assets`
    - This will compile the [React] UI and generate a [Go] file at
      `web/ui/assets_vfsdata.go`
  - Take the generated file and commit it to this repository under the same
    path, `web/ui/assets_vfsdata.go`
  - Create a new tag that matches the version of Prometheus that the asset was
    generated for
    - eg. `git tag -m "Tagging v2.14.0" v2.14.0`
  - Push the commits and tags to GitHub
    - `git push && git push --tags`
  - Test and submit the updated `net-mgmt/prometheus2` port as usual

In addition to building the asset manually as shown above, there is a helper
script named `makeasset.sh`. The script will perform the checkout of Prometheus
at a specified version, followed by the compilation of the asset, and copying
it into the correct location within the repository. Committing the asset to the
repository, tagging, and pushing the new version remain manual operations.

<!-- document links -->
[`devel/gmake`]: https://www.freshports.org/devel/gmake
[`lang/go`]: https://www.freshports.org/lang/go
[`net-mgmt/prometheus2`]: https://github.com/freebsd/freebsd-ports/tree/master/net-mgmt/prometheus2
[`www/node10`]: https://www.freshports.org/www/node10
[`www/yarn-node10`]: https://www.freshports.org/www/yarn-node10
[FreeBSD]: https://www.freebsd.org/
[Go]: https://golang.org/
[Prometheus]: https://prometheus.io/
[Prometheus repository]: https://github.com/prometheus/prometheus
[React]: https://reactjs.org/
[Yarn]: https://yarnpkg.com/
