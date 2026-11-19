class Structured < Formula
  desc "CLI for Structured, the daily planner"
  homepage "https://structured.app"
  version "0.7.0"
  license :cannot_represent

  # Building from source needs SSH access to the private repository.
  head do
    url "ssh://git@github.com/unorderly/structured-cli.git", branch: "main"
    depends_on "go" => :build
  end

  # Prebuilt binaries are published to this tap's own releases, so installing
  # does not require access to the private structured-cli source repository.
  on_macos do
    depends_on macos: :sonoma
    depends_on arch: :arm64
    url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.7.0/structured-darwin-arm64"
    sha256 "8a51e46e417fcf4395dd260c94fde2b2739964ec858ed359455d0f3d389c2569"
  end

  on_linux do
    on_arm do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.7.0/structured-linux-arm64"
      sha256 "83c17b63145ca433dd92a2eebfa06dab0d98924efc6213b10b39cebb40c01f06"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.7.0/structured-linux-x64"
      sha256 "64c90d3726165556f8b5b2b5e4cfe968c3d7935ecfb39d166af1a188f8add833"
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
