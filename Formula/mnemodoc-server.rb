class MnemodocServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/mnemodoc/mcp-server"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-darwin-arm64"
      sha256 "050465602d2195d8a6a1dba28f348baa64c355a26d690c326f06a3f1cfa431e6"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-darwin-amd64"
      sha256 "a51268093dfc8f2b5e15b6d71f43dfae78fe9cf5961a4fce017cb8116b782a1b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-linux-arm64"
      sha256 "61aabf956bf472596d4744b67abb910d984ac058ab537c4a5cae5ff7646d588a"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-linux-amd64"
      sha256 "19f90fb59594122869705210407d0c3fc207dcc1d7e60b17396064dee746bb93"
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
