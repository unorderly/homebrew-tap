class Structured < Formula
  desc "CLI for Structured, the daily planner"
  homepage "https://structured.app"
  version "0.8.0"
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
    url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.8.0/structured-darwin-arm64"
    sha256 "cb9cdc8cca730e811c613e9289f773d9055f506183fd1c9f5aa363dd0b31b5b2"
  end

  on_linux do
    on_arm do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.8.0/structured-linux-arm64"
      sha256 "80f2f9662a2ea296571a3c9376046fd9bd831cf61665a2858507b4ce96460265"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.8.0/structured-linux-x64"
      sha256 "7c89000c59df5b9143f2c443185258586d0b1d256497d82690ab7967521584e9"
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
