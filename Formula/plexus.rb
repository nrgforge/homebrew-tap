class Plexus < Formula
  desc "Network-aware knowledge graph engine with self-reinforcing edges"
  homepage "https://github.com/nrgforge/plexus"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/plexus/releases/download/v0.6.0/plexus-aarch64-apple-darwin.tar.xz"
      sha256 "aa1f70fb2415b04c786a1d5abfa125ff3ebe620ac32ae761b79306313d64779d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/plexus/releases/download/v0.6.0/plexus-x86_64-apple-darwin.tar.xz"
      sha256 "1d4eb6e7059d94afbc309e09d1c0b9e08a5681ab82edae0e0f72b708c2db2cd2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/plexus/releases/download/v0.6.0/plexus-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "073b189cfb35dc548c0c12a9c2b4ff3b6ab506bfcbc38a485079dc5e11d13a63"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/plexus/releases/download/v0.6.0/plexus-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "31257beaca3620b093715ae5b05e7340ed7eaf97a1ea2bd4bfc8373a537962d1"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "plexus"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "plexus"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "plexus"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "plexus"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
