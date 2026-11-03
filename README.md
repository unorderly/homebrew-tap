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
  to `unorderly/structured-cli`. This pure-Go source build does not include NLP.

macOS requires macOS 14+ and Apple Silicon (arm64). Prebuilt macOS releases
include the Swift natural-language parser; `add --nl` and `edit --title ... --nl`
require macOS 26+. No Xcode or separate Swift installation is needed.
Linux supports arm64 and x86-64 and does not include NLP.
The same platform requirements apply when building with `--HEAD`.

## Releasing a new version

Releases are explicitly dispatched; pushing a tag alone does not start a paid
macOS runner or publish. In `structured-cli`, tag the intended commit and run:

```bash
gh workflow run release.yml --ref vX.Y.Z
```

The workflow builds Linux on Ubuntu and native Apple Silicon on macOS 26. All
Linux checks and the full Swift/Go native tests must pass before publication.
It creates the source release, then mirrors binaries to a `structured-vX.Y.Z`
release here and updates `version` and `sha256` in `Formula/structured.rb`.

Automatic tap publishing needs a `TAP_GITHUB_TOKEN` secret in `structured-cli`: a
fine-grained personal access token (or GitHub App installation token) scoped to
`unorderly/homebrew-tap` with **Contents: read and write**. If unset, the workflow
reports Homebrew publishing as pending. Finish from the CLI checkout using your
own credentials:

```bash
bash scripts/publish-to-tap.sh vX.Y.Z
```

Release assets are attached to releases rather than committed, so this repository stays small
even though every user clones it when they tap.
