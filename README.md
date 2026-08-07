# Homebrew tap for Structured

This tap publishes the Structured CLI as `structured` and installs `strct` as a short alias.

## Install

```bash
brew tap unorderly/tap
brew install structured
```

Then either command works:

```bash
structured today
strct today
```

## How distribution works

The CLI source lives in the private `unorderly/structured-cli` repository, but nobody needs
access to it in order to install:

- `brew install structured` downloads a prebuilt binary from this tap's own releases. This
  repository is public, so the download needs no authentication.
- `brew install --HEAD structured` builds from `main` with Go over SSH. This requires access
  to `unorderly/structured-cli`.

Binaries are built for macOS (arm64, x86-64) and Linux (arm64, x86-64).

## Releasing a new version

Releases are automated. Pushing a `v*` tag in `structured-cli` runs its `Release` workflow,
which cross-compiles every target, publishes the binaries to a `structured-v*` release in
this repository, and commits the updated `version` and `sha256` values into
`Formula/structured.rb`.

That workflow needs a `TAP_GITHUB_TOKEN` secret in `structured-cli`: a fine-grained personal
access token (or GitHub App installation token) scoped to `unorderly/homebrew-tap` with
**Contents: read and write**.

Release assets are attached to releases rather than committed, so this repository stays small
even though every user clones it when they tap.
