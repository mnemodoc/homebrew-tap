class Mcpctl < Formula
  desc "Declare MCP servers once for Claude Code and Zed, secrets in the OS store"
  homepage "https://github.com/mnemodoc/mcpctl"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.0/mcpctl-darwin-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.0/mcpctl-darwin-amd64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.0/mcpctl-linux-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.0/mcpctl-linux-amd64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
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
