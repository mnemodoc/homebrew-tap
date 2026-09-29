class MnemodocServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/mnemodoc/mcp-server"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.1/mnemodoc-server-darwin-arm64"
      sha256 "aad83febdaedb42178cc8adacd9158daf9008e808a2edaf78ba8e2b7bb348764"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.1/mnemodoc-server-darwin-amd64"
      sha256 "2beade8c65f1ca52709bcbca3c370ce9fc3b0d40afec4ef31d932ebbed3523fd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.1/mnemodoc-server-linux-arm64"
      sha256 "b42da9dec8268561a9f44f171c994d9979f80d9ca9dad504724ebba92f8b09be"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.5.1/mnemodoc-server-linux-amd64"
      sha256 "e4f0fe902b0da2132389cfea48426dd5acda507d7ad63d0e402a8c9d416316ec"
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
