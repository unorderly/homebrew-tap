class Structured < Formula
  desc "CLI for Structured, the daily planner"
  homepage "https://structured.app"
  url "ssh://git@github.com/unorderly/structured-cli.git",
      tag:      "v0.1.0",
      revision: "0fe5dc4cae2c8ea941ce64a42967dff1371962f8"
  license :cannot_represent

  head "ssh://git@github.com/unorderly/structured-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", "-trimpath", "-ldflags=-s -w", "-o", bin/"structured", "./cmd/structured"

    bin.install_symlink bin/"structured" => "strct"
  end

  test do
    assert_match "structured version", shell_output("#{bin}/structured --version")
    assert_match "structured version", shell_output("#{bin}/strct --version")
  end
end
