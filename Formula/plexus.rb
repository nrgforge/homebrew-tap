class Plexus < Formula
  desc "Network-aware knowledge graph engine with self-reinforcing edges"
  homepage "https://github.com/nrgforge/plexus"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/plexus/releases/download/v0.3.0/plexus-aarch64-apple-darwin.tar.xz"
      sha256 "9a87a84c3e2e94b010ae639a688750fdbca9c5e7f406c05886fca1ebf43fea6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/plexus/releases/download/v0.3.0/plexus-x86_64-apple-darwin.tar.xz"
      sha256 "6f934b3aaf84489abb215d7dc208a235e1308906c140c8b213e9fd37d36ab2c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/plexus/releases/download/v0.3.0/plexus-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d3df593a508652747719bd141b540f69bd0e20ab5d69022de9b2261afb7771b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/plexus/releases/download/v0.3.0/plexus-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1bf4d446e2dd3659cc42b589ec3eae8a64ab0b4078e0240cf1238a5c3b8c946c"
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
