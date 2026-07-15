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

## Current source setup

The formula currently builds from the private source repository over SSH:

```text
ssh://git@github.com/unorderly/structured-cli.git
```

So installers need GitHub/SSH access to `unorderly/structured-cli`. The stable formula points at tag `v0.1.2`; make sure that tag is pushed before sharing the tap:

```bash
cd ../structured-cli
git push origin v0.1.2
```

To install from the latest `main` instead of the stable tag:

```bash
brew install --HEAD structured
```

## Publishing this tap

After creating `github.com/unorderly/homebrew-tap`:

```bash
git remote add origin git@github.com:unorderly/homebrew-tap.git
git push -u origin main
```

Because the repo name is `homebrew-tap`, users tap it as `unorderly/tap`.

## Updating for a new release

1. Tag and push a release in `structured-cli`.
2. Update `Formula/structured.rb` with the new tag and commit revision.
3. Commit and push this tap.
