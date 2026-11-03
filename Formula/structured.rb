class Structured < Formula
  desc "CLI for Structured, the daily planner"
  homepage "https://structured.app"
  version "0.5.0"
  license :cannot_represent

  # Building from source needs SSH access to the private repository.
  head do
    url "ssh://git@github.com/unorderly/structured-cli.git", branch: "main"
    depends_on "go" => :build
  end

  # Prebuilt binaries are published to this tap's own releases, so installing
  # does not require access to the private structured-cli source repository.
  on_macos do
    depends_on arch: :arm64
    url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.5.0/structured-darwin-arm64"
    sha256 "2787c56f0e73d58523e7e74b2a6611ab7569ad0a202576a6bd3153371486a6e5"
  end

  on_linux do
    on_arm do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.5.0/structured-linux-arm64"
      sha256 "b3542e93db125a700f78ef199cdab2ac9c9bc9c4f7b5b4d3cb5344bfbdba4b6e"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.5.0/structured-linux-x64"
      sha256 "aa4a75a3813947cef54c7d6c41851a1c0a72ee6669f19e58fe3e099ed66b9fb3"
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
