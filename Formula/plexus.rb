class Plexus < Formula
  desc "Network-aware knowledge graph engine with self-reinforcing edges"
  homepage "https://github.com/nrgforge/plexus"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/plexus/releases/download/v0.2.0/plexus-aarch64-apple-darwin.tar.xz"
      sha256 "527bfdbc7cda99a5c427f1ff96b7523c76bf0436c836a029d213313fd6657164"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/plexus/releases/download/v0.2.0/plexus-x86_64-apple-darwin.tar.xz"
      sha256 "dce143d8e7622085704a83869629a92d3f491e96f01749e6a6864f9f7b79a3e9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/plexus/releases/download/v0.2.0/plexus-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2cebbd64a09b14e1fcdb97806b96c6d5075de1db5e4601d55ac2cf28bbad6e7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/plexus/releases/download/v0.2.0/plexus-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa735ffdf6b6899f1b2b55002d24e3cc688d117ec5d68ea1912c5b0283f56fcc"
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
