class MnemodocServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/mnemodoc/mcp-server"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.3.1/mnemodoc-server-darwin-arm64"
      sha256 "f68f8ea9d4aa64251207207f3e6bab378fa31527c423ce68fd9acf6b576f4b40"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.3.1/mnemodoc-server-darwin-amd64"
      sha256 "49676eb680aaddfa7f41a8f8fafc35b0c0438265619bc6a9b5a2a73559125cc1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.3.1/mnemodoc-server-linux-arm64"
      sha256 "8c28ca2752600363d42a2cf9b9e873ab245445578414891f886edfca8ffa08bf"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.3.1/mnemodoc-server-linux-amd64"
      sha256 "e56f970b5e53462108e38f3eabd24e2a185de6901bee7b9f71d4e1658be467a3"
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
