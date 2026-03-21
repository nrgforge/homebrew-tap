class Plexus < Formula
  desc "Network-aware knowledge graph engine with self-reinforcing edges"
  homepage "https://github.com/nrgforge/plexus"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/plexus/releases/download/v0.1.0/plexus-aarch64-apple-darwin.tar.xz"
      sha256 "2ae69b48fba453c788743dd463f15ed2d97256ecf54d233f5251a25900558fa7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/plexus/releases/download/v0.1.0/plexus-x86_64-apple-darwin.tar.xz"
      sha256 "77d9dec21a23ac3e5c3aa367a6f4f7136246c811d67330f90286c732743d9d6d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/plexus/releases/download/v0.1.0/plexus-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f56e3125c4d2a55f8a7fd42799c8e7e7ee771f3063b79d3f3bfd5f127e9e90a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/plexus/releases/download/v0.1.0/plexus-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5be58f94bd96772955f80fa9d48f9e8219552bab77042217e8297b07f3b37a57"
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
