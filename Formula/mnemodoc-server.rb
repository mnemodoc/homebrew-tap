class MnemodocServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/mnemodoc/mcp-server"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-darwin-arm64"
      sha256 "29c7563f534d4f2a3f9a8e8659b6ac728f6a796e6a5732aac703ca2a61de6fb1"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-darwin-amd64"
      sha256 "fd156367ed3ba7c89194dd62ceecb60295b5a77dbded2fb9cfd3998790fe21ce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-linux-arm64"
      sha256 "8595a0f0d09956c2d43878cbbdb701cd83c94abce757fa4b2d12014203951f5b"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-linux-amd64"
      sha256 "e25a474bab0b90344044e11ae3108c4b1778990b8cc7eff78c6f97bf89b46db3"
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
