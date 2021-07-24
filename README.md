# haskell-dev-tools

This repo serves two purposes:

- Creating the docker image that is used to run the linter and formatter in
  the CI builds for the fossas/spectrometer repo.
- Automatically creating PRs for the image when the tools are updated.

Most of this repo is in the `.github/workflows` folder, but the two special
items are the Dockerfile, and the script that updates it: `update-dev-tools.sh`.

The image that is built is scoped to this repo as well as the org, but is made
publicly available, since there's no org-specific secrets or magic, and it
makes docker auth easier in spectrometer's CI. On that note, the code in this
repo is released warranty-free into the public domain, under
[The Unlicense](LICENSE).

The image is published as `ghcr.io/fossas/haskell-dev-tools:{version}`, where
`version` is the GHC compiler version we target.
