class MnemodocServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/mnemodoc/mcp-server"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.0/mnemodoc-server-darwin-arm64"
      sha256 "9e1425d46901585be295fee7ee409353a25f2c6ae497973c814b296b5df3bf67"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.0/mnemodoc-server-darwin-amd64"
      sha256 "56953310dedf7c8cfc26bd6f5d072fca0d3f8c9652d0a9ef21c47e6d055e1399"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.0/mnemodoc-server-linux-arm64"
      sha256 "979081a5fb66a076f6b5614eb09dc9f1dcb08c185f6c49c8cd5a1bff32a683f5"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.0/mnemodoc-server-linux-amd64"
      sha256 "a5d0f8755c67b1e2bd56ee23d1c12d1346d9de4635ae3ab7ec281389e7667bd3"
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
