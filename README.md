# homebrew-tap

[![Audit](https://github.com/mnemodoc/homebrew-tap/actions/workflows/audit.yml/badge.svg)](https://github.com/mnemodoc/homebrew-tap/actions/workflows/audit.yml)

Homebrew tap for [mnemodoc](https://github.com/mnemodoc) tools.

## Install

```sh
brew tap mnemodoc/tap
```

Then install any formula:

```sh
brew install mnemodoc/tap/mnemodoc-server
```

## Update

Homebrew only sees a new release once the tap itself is refreshed:

```sh
brew update
brew upgrade mnemodoc/tap/mnemodoc-server
```

Check what is installed:

```sh
mnemodoc-server --version
```

`brew update` pulls the tap from GitHub, not from a local checkout: a formula
edited locally but not pushed stays invisible to the upgrade.

## Formulae

| Formula | Description |
|---------|-------------|
| [`mnemodoc-server`](https://github.com/mnemodoc/mcp-server) | Crystal MCP server that indexes documentation via Ollama embeddings |
