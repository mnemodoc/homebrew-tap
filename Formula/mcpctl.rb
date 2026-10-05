class Mcpctl < Formula
  desc "Declare MCP servers once for Claude Code and Zed, secrets in the OS store"
  homepage "https://github.com/mnemodoc/mcpctl"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.1/mcpctl-darwin-arm64"
      sha256 "0130bb22e5eb1b98ff4130ab57e6e685929f73add1d4f9e31e551aee91e8f0de"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.1/mcpctl-darwin-amd64"
      sha256 "cb4ae263cea00b25d6b0c2078eb9a1c6c3ea872582ff6a6e2ff8cba7d015a12e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.1/mcpctl-linux-arm64"
      sha256 "cb5b10e3389714591927e7b9f2f8eaebb86d7307d21bfdfdaa7e59efad8f4eac"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.1/mcpctl-linux-amd64"
      sha256 "141bcb68a9b7f3c5c6344900f9d1729e3da13be53b85eebf90ddf22018b0dbd9"
    end
  end

  def install
    binary = Dir["mcpctl-*"].first
    bin.install binary => "mcpctl"
  end

  test do
    output = shell_output("#{bin}/mcpctl --version")
    assert_match version.to_s, output
  end
end
