# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Rules

### Analysis

**Memory is forbidden as a source:** acting or producing anything from memory is **prohibited** — whether training memory or session context. Commands, paths, names, patterns, conventions, behaviors: anything not read from a file or source in the **current turn** is forbidden as the basis for an action or assertion. If the information is not in the current turn: read before acting — never assume. Without a source, say "I don't know" or "I need to read X before responding".

## Project

Homebrew tap for `mnemodoc` tools, hosted at `https://github.com/mnemodoc/homebrew-tap`.
Lets users install tools with `brew install mnemodoc/tap/<formula>`.

Currently contains one formula: `mnemodoc-server` — a Crystal MCP server that indexes documentation via Ollama embeddings.

## Key commands

```bash
# Audit formula style locally (requires Homebrew)
# `brew tap <name> <path>` CLONES the checkout into
# $(brew --repository mnemodoc/tap); it does not follow the working tree.
# Uncommitted edits are invisible to the audit until copied over:
#   cp Formula/mnemodoc-server.rb "$(brew --repository mnemodoc/tap)/Formula/"
brew tap mnemodoc/tap "$(pwd)"
# Mandatory: Homebrew refuses to load formulae from an untrusted third-party
# tap, and `brew audit` then silently audits nothing and exits 0.
brew trust mnemodoc/tap
brew audit --strict mnemodoc-server

# Test the SHA update script with dummy values
python3 scripts/update_formula.py \
  --formula Formula/mnemodoc-server.rb \
  --version 0.1.0 \
  --darwin-arm64 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \
  --darwin-amd64 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb \
  --linux-arm64  cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc \
  --linux-amd64  dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
```

## Architecture

| File | Role |
|------|------|
| `Formula/mnemodoc-server.rb` | Homebrew formula — downloads pre-built static binary per platform |
| `scripts/update_formula.py` | CLI script to bump version + SHA256 in the formula. Manual use only: CI runs its own copy, see below |
| `.github/workflows/audit.yml` | CI — runs `brew audit --strict` on every push/PR |

The auto-update flow lives in the **`mcp-server` repo** (not here), in `.github/workflows/release-tap.yml`. On each release it: downloads the 4 platform binaries, computes SHA256, then runs **its own** `scripts/update_formula.py` against this repository's formula and opens a PR here.

That script is a copy of the one below, and it lives there on purpose: it runs in the same job as `TAP_GITHUB_TOKEN`, so it must be code the workflow's own repository reviews and versions. Executing this repository's copy would have made write access here enough to run arbitrary code alongside that token. The copy kept here stays valid for the manual command documented above; when one changes, port the change to the other.

## Formula details

The formula supports 4 platform targets via `on_macos`/`on_linux` + `on_arm`/`on_intel` blocks:
- `darwin-arm64`, `darwin-x86_64`, `linux-arm64`, `linux-x86_64`

Binary filenames from releases follow the pattern `mnemodoc-server-<platform>`. The `install` block renames the downloaded file to `mnemodoc-server`.

**Never add a `version` line.** Homebrew scans the version from the `v<version>` release tag in the download URLs; declaring it as well makes `brew audit --strict` fail with `` `version X` is redundant with version scanned from URL `` (rule in Homebrew's `resource_auditor.rb`). That is why the URLs carry the literal version instead of interpolating `#{version}`, and why the version is duplicated across the four URLs — `scripts/update_formula.py` is what rewrites them.

## SHA update script

`scripts/update_formula.py` uses regex to replace the version and the `sha256` values in-place. The version is rewritten inside the `/releases/download/v<version>/` segment of every URL, not on a `version` line — the formula deliberately has none (see "Formula details"). It matches sha256 lines by looking for the URL containing the platform slug immediately above them. If no download URL is found, or a platform slug is missing, the script exits with code 1.

## CI tap resolution

The audit workflow has **no** tap step: `Homebrew/actions/setup-homebrew` attaches the checkout as the `mnemodoc/tap` tap by itself, so `brew audit --strict mnemodoc-server` resolves to `mnemodoc/tap/mnemodoc-server` from the checked-out branch, not from the pushed `master`. Do not add a `brew tap` step — locally it is needed, in CI it is not.

## Auto-update prerequisite

A fine-grained PAT with Contents + Pull requests (read+write) on `mnemodoc/homebrew-tap` must be stored as secret `TAP_GITHUB_TOKEN` on `mnemodoc/mcp-server`.
