class MnemodocServer < Formula
  desc "Crystal MCP server that indexes documentation via Ollama embeddings"
  homepage "https://github.com/mnemodoc/mcp-server"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.4.0/mnemodoc-server-darwin-arm64"
      sha256 "587fc80913feacb441d94232af5cfc7a141b01144c0b574033202db2902acb4a"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.4.0/mnemodoc-server-darwin-amd64"
      sha256 "8907f141e8e6fa435555aae5c25aa2b9788d1f0871c89c2eea5c2fd79d9889b4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.4.0/mnemodoc-server-linux-arm64"
      sha256 "14cbdefdadc8309b69f07b3de1ded0297d4a9906e2a351ad0e1eaf44c8d20ac9"
    end
    on_intel do
      url "https://github.com/mnemodoc/mcp-server/releases/download/v1.4.0/mnemodoc-server-linux-amd64"
      sha256 "d738ea9e4abbad4d3faa8737fb8cd084a82c3d60fe4b87007734aceb9a102081"
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
