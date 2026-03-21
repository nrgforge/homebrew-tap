class Zani < Formula
  desc "A terminal writing app"
  homepage "https://github.com/nrgforge/zani"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/zani/releases/download/v0.1.0/zani-aarch64-apple-darwin.tar.xz"
      sha256 "5e389c3db3f6f4dace67fb9e0494aff2842d940d31b5f9571153a850e2ab289e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/zani/releases/download/v0.1.0/zani-x86_64-apple-darwin.tar.xz"
      sha256 "a0bd9e37bfe194cd1d90e47f37e4b12bd8e353bd9dc438c39195c4475f4d266d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/zani/releases/download/v0.1.0/zani-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0d3b50eac77850b76dcc1724858a2c46a24157a223186638f53e44dfebfba873"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/zani/releases/download/v0.1.0/zani-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d1d303d5520622ad3c4b9b3623e0c917a6854c285588e44655acf00564f874e6"
    end
  end
  license "MIT"

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
    bin.install "zani" if OS.mac? && Hardware::CPU.arm?
    bin.install "zani" if OS.mac? && Hardware::CPU.intel?
    bin.install "zani" if OS.linux? && Hardware::CPU.arm?
    bin.install "zani" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
