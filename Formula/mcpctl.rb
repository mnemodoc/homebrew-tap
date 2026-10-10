class Mcpctl < Formula
  desc "Declare MCP servers once for Claude Code and Zed, secrets in the OS store"
  homepage "https://github.com/mnemodoc/mcpctl"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.2.0/mcpctl-darwin-arm64"
      sha256 "a25b5a0c59b8a6c9029ce2c47ec2ee7b181419f1762e364dc1e0cb00fed84b25"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.2.0/mcpctl-darwin-amd64"
      sha256 "1e9033a7ed5d08c0c126ad0762827f51a39120ab4c2c9a0c470a1f65ffa5965b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.2.0/mcpctl-linux-arm64"
      sha256 "32edeea0549ff88aa3a352c389311ea79e112003bedf442c6c5ef0147cfa3fdc"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.2.0/mcpctl-linux-amd64"
      sha256 "b76f0baa51a57d0991665e4e45e69128edeed32ff2a24f27a1f184cf47b652e0"
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
