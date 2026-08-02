class MnemodocServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/mnemodoc/mcp-server"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.2.0/mnemodoc-server-darwin-arm64"
      sha256 "ff825b3ac42f26407db0de24b0372b197881a56d88f15383d614c83460376a6f"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.2.0/mnemodoc-server-darwin-amd64"
      sha256 "6f11a87554969dbee7b325b92ee2981a564857c22740e9aca642bfce90399666"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.2.0/mnemodoc-server-linux-arm64"
      sha256 "d5e7f44238253ddb8a1a933de7a3c9f70cb7d95995bb521da88f67fca23bb676"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.2.0/mnemodoc-server-linux-amd64"
      sha256 "6c382c6b65e6c6770781c0c5f738fb5473d8a92d32ceb799ea13d17fc5290904"
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
