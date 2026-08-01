class MnemodocServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/mnemodoc/mcp-server"
  version "1.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-darwin-arm64"
      sha256 "4ea263602fde6663638b913116ed287d8a8744b5d4ec9b0ae62869f275581a5a"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-darwin-amd64"
      sha256 "624eb59d0ded962f192531e941aaef34a66df747222c3d57d3c3b4044491260d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-linux-arm64"
      sha256 "a2d77bf0d389b87e409118660dbaa249f71ab2ac59ae9d4c2afdae90d77c1f03"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v#{version}/mnemodoc-server-linux-amd64"
      sha256 "60ca5b247331be07f4d2074d5566b3e7324f5344e3fa90e8b55de0d0b7d18579"
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
