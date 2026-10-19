class Structured < Formula
  desc "CLI for Structured, the daily planner"
  homepage "https://structured.app"
  version "0.3.0"
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
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.3.0/structured-darwin-arm64"
      sha256 "fb3e4c9260d9fd939f7f8c87e6f0d76c94e52b7dddc573a9bfbb5cc2d4cc04f9"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.3.0/structured-darwin-x64"
      sha256 "4b26f374bba0f2af96bd3532a519a03836f28d3b10100a7a42b42c404ab607a7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.3.0/structured-linux-arm64"
      sha256 "a06330c66d4ae307af12c612284a346ac05591dd1a582f41b03903eeb58aefc9"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.3.0/structured-linux-x64"
      sha256 "934f94d4b8f77b0dbdc7e53fd334dbed555e4ede75cd3fc3620f95a92b26f119"
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
