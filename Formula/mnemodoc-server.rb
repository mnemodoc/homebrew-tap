class MnemodocServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/mnemodoc/mcp-server"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.3/mnemodoc-server-darwin-arm64"
      sha256 "69eee01a5c657be57bf998e73411f2eb2f91f20b4f0446e9cc36929adf23e413"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.3/mnemodoc-server-darwin-amd64"
      sha256 "5a6b997c6938aef86222d5fdb9c3fab0cdff6c34da1e92819c800c651103255f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.3/mnemodoc-server-linux-arm64"
      sha256 "01ab83f3d37259d8f32a6e40de1343f52a892580ad39bfcb0ba3ef4d8cf1663b"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.3/mnemodoc-server-linux-amd64"
      sha256 "0f618916d9bc4537ea327b2961329c0386de96aa4f57d97e44208a33d9af5b3c"
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
