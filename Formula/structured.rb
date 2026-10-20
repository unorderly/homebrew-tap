class Structured < Formula
  desc "CLI for Structured, the daily planner"
  homepage "https://structured.app"
  version "0.4.0"
  license :cannot_represent

  # Building from source needs SSH access to the private repository.
  head do
    url "ssh://git@github.com/unorderly/structured-cli.git", branch: "main"
    depends_on "go" => :build
  end

  # Prebuilt binaries are published to this tap's own releases, so installing
  # does not require access to the private structured-cli source repository.
  on_macos do
    on_arm do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.4.0/structured-darwin-arm64"
      sha256 "392387d9c9bd1faf4cd99a34ab8b0dd6dc7ba673024d16294f008482c7a8da78"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.4.0/structured-darwin-x64"
      sha256 "9f03f1f9b64d17aaae1f1dbab491dee3d9430b70697b3e9d960c0cb0cd000521"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.4.0/structured-linux-arm64"
      sha256 "b58e50b3a623ae18dd4c83c9413e9b21ef1631e5d6b746fd778ef2b0d9eacbf8"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.4.0/structured-linux-x64"
      sha256 "787e6e3399e465937fe7bbdc2b5532c1d9f8ab68193c20206bdce77e3acc2db2"
    end
  end

  def install
    if build.head?
      ENV["CGO_ENABLED"] = "0"
      ldflags = "-s -w -X github.com/unorderly/structured-cli/internal/cli.version=#{version}"
      system "go", "build", "-trimpath", "-ldflags=#{ldflags}", "-o", bin/"structured", "./cmd/structured"
    else
      bin.install Dir["structured-*"].first => "structured"
    end

    bin.install_symlink bin/"structured" => "strct"
  end

  test do
    assert_match "structured version", shell_output("#{bin}/structured --version")
    assert_match "structured version", shell_output("#{bin}/strct --version")
  end
end
