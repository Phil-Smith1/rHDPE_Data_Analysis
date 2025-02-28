# BD4BS Shiny Utils

This code contains an R package for developing R Shiny apps which interact with the BD4BS platform.
See the vignette for further details.

For further details contact Dave Brett/Nik Burkoff.

## Build

This package is now built automatically on our Azure DevOps account.  `Bd4bsShinyUtils-pr` runs on pull requests that affect files in this package and
`Bd4bsShinyUtils-full` runs on commits to `master` that affect files in this package.  Unit tests are run as part of the build and the completed package as a
`tar.gz` file is published as an artifact on the `full` build.

Definitions for both builds are found in the `build` directory.  They use the root level `Dockerfile.ShinyUtils.Build` file to execute the build in Docker.
