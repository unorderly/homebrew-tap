class Structured < Formula
  desc "CLI for Structured, the daily planner"
  homepage "https://structured.app"
  version "0.2.0"
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
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.2.0/structured-darwin-arm64"
      sha256 "6e225826f36b3ce77208aa35f29a5fd5e65258bd2467b4e458708b58dbd5570d"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.2.0/structured-darwin-x64"
      sha256 "7ad0359583d185792b6e87636b0e1a1877280063a6c93cf9bdbf4400c73b26ef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.2.0/structured-linux-arm64"
      sha256 "30220f7322edf1fc263e7d94f8330d28713b4960bbab9e55badc36a268b3f242"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.2.0/structured-linux-x64"
      sha256 "e780c5935d7eaecd31883e406aab762b3f6372ec578f1523142c0c625c1ed346"
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
