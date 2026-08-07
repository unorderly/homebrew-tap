class Structured < Formula
  desc "CLI for Structured, the daily planner"
  homepage "https://structured.app"
  version "0.1.2"
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
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.1.2/structured-darwin-arm64"
      sha256 "58dc873f42fee9f5da391d007813b887def4a9c982b778d0439f1d7e01c2c1eb"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.1.2/structured-darwin-x64"
      sha256 "a01a6bef91ae265096cf36e274930cc9b862e27ecb310dfafadb899c70310bdd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.1.2/structured-linux-arm64"
      sha256 "975ce0e2f57af33955499ac8abb37a5343ac2d867c3b5324fbbb4e234c81e672"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.1.2/structured-linux-x64"
      sha256 "1005a87ba6d8c680cdf2c747de82b068dc174ea314f13fbb1ed196c5c796efe3"
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
