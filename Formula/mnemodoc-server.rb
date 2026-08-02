class MnemodocServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/mnemodoc/mcp-server"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.3.0/mnemodoc-server-darwin-arm64"
      sha256 "5c1749f9b8aa290d1d795fe351383e74f57bda6b4c0601500d1d9111ecd8e280"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.3.0/mnemodoc-server-darwin-amd64"
      sha256 "2dda198b38c3f660524bce503c6406fd16181391cea3effdcee809a772a8bfc9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.3.0/mnemodoc-server-linux-arm64"
      sha256 "c0c930c40675e5d5be8419e5c51a8f8199a731db616981eb98ea8a5464ac20aa"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.3.0/mnemodoc-server-linux-amd64"
      sha256 "3aaf20119c05810e100686e9b3df225a5d03c2cba4b4d7c348c518c9c942e275"
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
