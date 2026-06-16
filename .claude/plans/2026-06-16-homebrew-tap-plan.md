# Homebrew Tap `jbox-web/homebrew-tap` — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a Homebrew tap at `jbox-web/homebrew-tap` that lets users install `mcp-grimoire-server` with `brew install jbox-web/tap/mcp-grimoire-server`, with formula auto-update on each GitHub release.

**Architecture:** The tap is a standalone GitHub repo containing Ruby formula files. A GitHub Action in the `mcp-grimoire-server` repo triggers on release, computes SHA256 for each binary, and opens a PR on the tap to bump the version.

**Tech Stack:** Ruby (Homebrew formula DSL), GitHub Actions, Bash, Python (SHA update script).

---

## File Map

| File | Responsibility |
|------|---------------|
| `Formula/mcp-grimoire-server.rb` | Homebrew formula — download + install binary |
| `scripts/update_formula.py` | Update version + SHA256 in formula from CLI args |
| `.github/workflows/audit.yml` | CI — runs `brew audit` on every PR/push |
| `README.md` | Usage instructions for the tap |

**In `mcp-grimoire-server` repo (separate, added in Task 3):**

| File | Responsibility |
|------|---------------|
| `.github/workflows/release-tap.yml` | On release: compute SHAs, open PR on tap |

---

## Task 1: Scaffold the tap repository

**Files:**
- Create: new GitHub repo `jbox-web/homebrew-tap`
- Create: `README.md`
- Create: `.gitignore`

- [ ] **Step 1: Create the repo locally**

```bash
mkdir -p ~/PROJECTS/homebrew-tap
cd ~/PROJECTS/homebrew-tap
git init
mkdir -p Formula scripts .github/workflows
```

- [ ] **Step 2: Write `README.md`**

```markdown
# homebrew-tap

Homebrew tap for [jbox-web](https://github.com/jbox-web) tools.

## Install

```sh
brew tap jbox-web/tap
```

Then install any formula:

```sh
brew install jbox-web/tap/mcp-grimoire-server
```

## Formulae

| Formula | Description |
|---------|-------------|
| `mcp-grimoire-server` | Crystal MCP server that indexes documentation via Ollama embeddings |
```

- [ ] **Step 3: Write `.gitignore`**

```
.DS_Store
```

- [ ] **Step 4: Initial commit**

```bash
git add .
git commit -m "chore: init homebrew tap"
```

- [ ] **Step 5: Push to GitHub**

Create the repo on GitHub first (`jbox-web/homebrew-tap`), then:

```bash
git remote add origin https://github.com/jbox-web/homebrew-tap.git
git push -u origin main
```

---

## Task 2: Write the formula

**Files:**
- Create: `Formula/mcp-grimoire-server.rb`

The formula downloads the pre-built static binary directly from GitHub Releases.
SHA256 values are placeholders — they will be filled in by the auto-update action
on the first real release. For local testing, replace them with real SHAs.

- [ ] **Step 1: Write `Formula/mcp-grimoire-server.rb`**

```ruby
class McpGrimoireServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/jbox-web/mcp-grimoire-server"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jbox-web/mcp-grimoire-server/releases/download/v#{version}/mcp-grimoire-server-darwin-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/jbox-web/mcp-grimoire-server/releases/download/v#{version}/mcp-grimoire-server-darwin-x86_64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jbox-web/mcp-grimoire-server/releases/download/v#{version}/mcp-grimoire-server-linux-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/jbox-web/mcp-grimoire-server/releases/download/v#{version}/mcp-grimoire-server-linux-x86_64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    # The downloaded file is named after the URL's last segment.
    # Rename it to the canonical binary name.
    binary = Dir["mcp-grimoire-server-*"].first
    bin.install binary => "mcp-grimoire-server"
  end

  test do
    output = shell_output("#{bin}/mcp-grimoire-server info")
    assert_match version.to_s, output
  end
end
```

- [ ] **Step 2: Commit**

```bash
git add Formula/mcp-grimoire-server.rb
git commit -m "feat: add mcp-grimoire-server formula"
```

---

## Task 3: SHA update script

**Files:**
- Create: `scripts/update_formula.py`

This script is called by the GitHub Action with the new version and SHA256 values.
It updates the formula in-place using targeted regex substitutions.

- [ ] **Step 1: Write `scripts/update_formula.py`**

```python
#!/usr/bin/env python3
"""Update version and SHA256 checksums in a Homebrew formula.

Usage:
    python3 scripts/update_formula.py \\
        --formula Formula/mcp-grimoire-server.rb \\
        --version 0.2.0 \\
        --darwin-arm64   <sha256> \\
        --darwin-x86-64  <sha256> \\
        --linux-arm64    <sha256> \\
        --linux-x86-64   <sha256>
"""
import argparse
import re
import sys
from pathlib import Path


def replace_version(content: str, version: str) -> str:
    return re.sub(r'version "\S+"', f'version "{version}"', content)


def replace_sha(content: str, platform: str, sha: str) -> str:
    """Replace the sha256 following the URL that contains `platform`."""
    pattern = re.compile(
        r'(url\s+"[^"]*' + re.escape(platform) + r'[^"]*"\s+sha256\s+)"[a-f0-9]{64}"',
        re.DOTALL,
    )
    result, n = pattern.subn(rf'\g<1>"{sha}"', content)
    if n == 0:
        print(f"ERROR: no sha256 found for platform {platform!r}", file=sys.stderr)
        sys.exit(1)
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--formula", required=True)
    parser.add_argument("--version", required=True)
    parser.add_argument("--darwin-arm64", required=True, dest="darwin_arm64")
    parser.add_argument("--darwin-x86-64", required=True, dest="darwin_x86_64")
    parser.add_argument("--linux-arm64", required=True, dest="linux_arm64")
    parser.add_argument("--linux-x86-64", required=True, dest="linux_x86_64")
    args = parser.parse_args()

    path = Path(args.formula)
    content = path.read_text()

    content = replace_version(content, args.version)
    content = replace_sha(content, "darwin-arm64",  args.darwin_arm64)
    content = replace_sha(content, "darwin-x86_64", args.darwin_x86_64)
    content = replace_sha(content, "linux-arm64",   args.linux_arm64)
    content = replace_sha(content, "linux-x86_64",  args.linux_x86_64)

    path.write_text(content)
    print(f"Updated {path} to v{args.version}")


if __name__ == "__main__":
    main()
```

- [ ] **Step 2: Verify the script works locally**

Using dummy values to confirm the regex fires correctly:

```bash
python3 scripts/update_formula.py \
  --formula Formula/mcp-grimoire-server.rb \
  --version 0.1.0 \
  --darwin-arm64  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \
  --darwin-x86-64 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb \
  --linux-arm64   cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc \
  --linux-x86-64  dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
```

Expected: the formula file is updated and `git diff` shows the SHAs replaced.

Revert after testing:
```bash
git checkout Formula/mcp-grimoire-server.rb
```

- [ ] **Step 3: Commit**

```bash
git add scripts/update_formula.py
git commit -m "feat: add formula update script"
```

---

## Task 4: Tap CI (brew audit)

**Files:**
- Create: `.github/workflows/audit.yml`

- [ ] **Step 1: Write `.github/workflows/audit.yml`**

```yaml
name: Audit

on:
  push:
    branches: [main]
  pull_request:

jobs:
  audit:
    name: brew audit
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Homebrew
        uses: Homebrew/actions/setup-homebrew@master

      - name: Tap this repo
        run: brew tap jbox-web/tap "$(pwd)"

      - name: Audit formula style
        # --except-cops=FormulaAudit/Homepage skips homepage checks for
        # projects that don't yet have a website
        run: brew audit --strict --except-cops=FormulaAudit/Homepage mcp-grimoire-server
```

- [ ] **Step 2: Commit and push**

```bash
git add .github/workflows/audit.yml
git commit -m "ci: add brew audit workflow"
git push
```

Expected: CI runs on GitHub, `brew audit` passes (formula style is valid even with placeholder SHAs).

---

## Task 5: Auto-update action (in `mcp-grimoire-server` repo)

**Files:**
- Create: `.github/workflows/release-tap.yml` in the `mcp-grimoire-server` repo

This action triggers after a release is published, downloads the four binaries,
computes their SHA256, and opens a PR on `jbox-web/homebrew-tap`.

Pre-requisite: create a GitHub Personal Access Token (PAT) with `repo` scope on
the `jbox-web` account and add it as a secret named `TAP_GITHUB_TOKEN` on the
`jbox-web/mcp-grimoire-server` repo.

- [ ] **Step 1: Create the PAT**

GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens:
- Repository access: `jbox-web/homebrew-tap`
- Permissions: Contents (read + write), Pull requests (read + write)

Save the token as secret `TAP_GITHUB_TOKEN` on `jbox-web/mcp-grimoire-server`.

- [ ] **Step 2: Write `.github/workflows/release-tap.yml`** (in `mcp-grimoire-server` repo)

```yaml
name: Update Homebrew tap

on:
  release:
    types: [published]

jobs:
  update-tap:
    name: Bump formula in jbox-web/homebrew-tap
    runs-on: ubuntu-latest
    steps:
      - name: Compute version
        id: version
        run: echo "value=${GITHUB_REF_NAME#v}" >> "$GITHUB_OUTPUT"

      - name: Download binaries and compute SHA256
        id: shas
        run: |
          VERSION="${{ steps.version.outputs.value }}"
          BASE="https://github.com/jbox-web/mcp-grimoire-server/releases/download/v${VERSION}"
          for ASSET in darwin-arm64 darwin-x86_64 linux-arm64 linux-x86_64; do
            curl -fsSL -o "$ASSET" "${BASE}/mcp-grimoire-server-${ASSET}"
            SHA=$(sha256sum "$ASSET" | awk '{print $1}')
            echo "${ASSET//-/_}=$SHA" >> "$GITHUB_OUTPUT"
          done

      - name: Checkout tap
        uses: actions/checkout@v4
        with:
          repository: jbox-web/homebrew-tap
          token: ${{ secrets.TAP_GITHUB_TOKEN }}
          path: homebrew-tap

      - name: Update formula
        run: |
          VERSION="${{ steps.version.outputs.value }}"
          python3 homebrew-tap/scripts/update_formula.py \
            --formula homebrew-tap/Formula/mcp-grimoire-server.rb \
            --version "$VERSION" \
            --darwin-arm64  "${{ steps.shas.outputs.darwin_arm64 }}" \
            --darwin-x86-64 "${{ steps.shas.outputs.darwin_x86_64 }}" \
            --linux-arm64   "${{ steps.shas.outputs.linux_arm64 }}" \
            --linux-x86-64  "${{ steps.shas.outputs.linux_x86_64 }}"

      - name: Open PR on tap
        uses: peter-evans/create-pull-request@v7
        with:
          token: ${{ secrets.TAP_GITHUB_TOKEN }}
          path: homebrew-tap
          branch: bump/mcp-grimoire-server-${{ steps.version.outputs.value }}
          title: "chore: bump mcp-grimoire-server to v${{ steps.version.outputs.value }}"
          body: |
            Automated bump triggered by release `v${{ steps.version.outputs.value }}`.

            SHA256 checksums updated for all four platform binaries.
          commit-message: "chore: bump mcp-grimoire-server to v${{ steps.version.outputs.value }}"
```

- [ ] **Step 3: Commit (in `mcp-grimoire-server` repo)**

```bash
git add .github/workflows/release-tap.yml
git commit -m "ci: auto-update homebrew tap on release"
```

---

## Post-implementation checklist

- [ ] Publish a first release (`v0.1.0`) on `jbox-web/mcp-grimoire-server` with the four binary assets
- [ ] Verify the `release-tap.yml` action runs and opens a PR on `jbox-web/homebrew-tap`
- [ ] Merge the PR — SHAs are now real
- [ ] Verify locally:
  ```sh
  brew tap jbox-web/tap
  brew install jbox-web/tap/mcp-grimoire-server
  mcp-grimoire-server info
  ```
- [ ] Verify `brew test mcp-grimoire-server` passes
