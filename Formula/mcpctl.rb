class Mcpctl < Formula
  desc "Declare MCP servers once for Claude Code and Zed, secrets in the OS store"
  homepage "https://github.com/mnemodoc/mcpctl"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.0/mcpctl-darwin-arm64"
      sha256 "2d0fc479fcdc702f46c1aeb6d9ce5f9a395a92342d77a1a7880602f0d8be922a"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.0/mcpctl-darwin-amd64"
      sha256 "ff7e2a3d31a2f0469425db51943af73e006b61c072269992342dc571d3039a27"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.0/mcpctl-linux-arm64"
      sha256 "15de4d55a08653227683cd72dc74b8ac9c67de36baacf205eefe4957ace2868b"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcpctl/releases/download/v0.1.0/mcpctl-linux-amd64"
      sha256 "df027e8737bd84972284b95bff6586b53dc8f1b8a93343f9827ae9d7fbdfb89e"
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
