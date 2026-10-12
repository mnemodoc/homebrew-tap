class Mcpctl < Formula
  desc "Declare MCP servers once for Claude Code and Zed, secrets in the OS store"
  homepage "https://github.com/mnemodoc/mcpctl"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.2.1/mcpctl-darwin-arm64"
      sha256 "44fffc18e4f26d13a0d7460f6b99434e5c6a05da95a64cc8d292b5c377c7de23"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.2.1/mcpctl-darwin-amd64"
      sha256 "50f0a2adddd3aaca31d82dfcefbfc3398548a6fcd3c0f2337db0d12d947aa07d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.2.1/mcpctl-linux-arm64"
      sha256 "633be59860633d1682c5d662e74822ef06a017b24321ae2b80f9bc27cd05c10b"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.2.1/mcpctl-linux-amd64"
      sha256 "4dfaf29969f55b305d46641731369e7e00a62fbdd7f72dcd87f6e865479b163d"
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
