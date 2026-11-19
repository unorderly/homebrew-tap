class Structured < Formula
  desc "CLI for Structured, the daily planner"
  homepage "https://structured.app"
  version "0.7.1"
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
    url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.7.1/structured-darwin-arm64"
    sha256 "20814ef3a3bd2fb45ade5eac0acbd7738ac65d68e8064849f42aa09ef55b241b"
  end

  on_linux do
    on_arm do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.7.1/structured-linux-arm64"
      sha256 "923e3d1eda33267bcfa8ae229fa5cdc98c2e00873b7e44c4d05cdfa323223474"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.7.1/structured-linux-x64"
      sha256 "6b7436ab4f6a391d1ac0ee9106bee7d3bf2f43faef78a111448f4566f10d5611"
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
