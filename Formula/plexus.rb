class Plexus < Formula
  desc "Network-aware knowledge graph engine with self-reinforcing edges"
  homepage "https://github.com/nrgforge/plexus"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/plexus/releases/download/v0.4.0/plexus-aarch64-apple-darwin.tar.xz"
      sha256 "9f804b7660351d60cf8beacb33fc0f3c8672467b20d373d5a424f8158cb5f1e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/plexus/releases/download/v0.4.0/plexus-x86_64-apple-darwin.tar.xz"
      sha256 "b4a9d2b52204cad96dd56c91be64b9fcd9dfecb76c83a08cc5b18b209e15a3ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/plexus/releases/download/v0.4.0/plexus-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b0b0cb17cacfc852157bb92ddc792f37a0d348c0722c800030c9644650981c69"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/plexus/releases/download/v0.4.0/plexus-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4b0b0920e03c9dc34b301ac54497e6c1a60ae8bb6f96f8207b3ab76d1e1b8276"
    end
  end
  license "AGPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "plexus" if OS.mac? && Hardware::CPU.arm?
    bin.install "plexus" if OS.mac? && Hardware::CPU.intel?
    bin.install "plexus" if OS.linux? && Hardware::CPU.arm?
    bin.install "plexus" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
