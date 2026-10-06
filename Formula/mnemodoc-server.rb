class MnemodocServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/mnemodoc/mcp-server"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.2/mnemodoc-server-darwin-arm64"
      sha256 "5e62351272f9a51e64ab8ba3e2615db76715a12ff81a6823d33e6fba1f084c0b"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.2/mnemodoc-server-darwin-amd64"
      sha256 "172567fdba19daa02b874731471b890511c58cd224462b960b709e03765fbad2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.2/mnemodoc-server-linux-arm64"
      sha256 "12ecd32dba1ea5bf91f6fb35f27d430471bc13c9e7aeec18512bc8b7cae05ab9"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.2/mnemodoc-server-linux-amd64"
      sha256 "9f5a86204f8843bd00c369dc18a723c87de6a8e4a0261c17f3fffc89dbeba8e1"
    end
  end

  def install
    binary = Dir["mnemodoc-server-*"].first
    bin.install binary => "mnemodoc-server"
  end

  test do
    output = shell_output("#{bin}/mnemodoc-server info")
    assert_match version.to_s, output
  end
end
