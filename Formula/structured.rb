class Structured < Formula
  desc "CLI for Structured, the daily planner"
  homepage "https://structured.app"
  version "0.5.1"
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
    url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.5.1/structured-darwin-arm64"
    sha256 "7d80930fc99cfb3ec05d125672e4d720527f5e2c9be28f06ce758700ae6cf7ce"
  end

  on_linux do
    on_arm do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.5.1/structured-linux-arm64"
      sha256 "508a889526894b7dbcaaefdb63bee4c586b9d069eb2e0e89bc2c69099a647ee0"
    end
    on_intel do
      url "https://github.com/unorderly/homebrew-tap/releases/download/structured-v0.5.1/structured-linux-x64"
      sha256 "13a852fea5301b1056d0a4805be281ec56d0734eaf81581c7cf2bb9444f9e10f"
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
