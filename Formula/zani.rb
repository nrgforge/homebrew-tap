class Zani < Formula
  desc "A terminal writing app"
  homepage "https://github.com/nrgforge/zani"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/zani/releases/download/v0.2.0/zani-aarch64-apple-darwin.tar.xz"
      sha256 "377f519ab81a2a7db9716cef9216056281d88bb917bc6edd5c1cba00c15a6535"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/zani/releases/download/v0.2.0/zani-x86_64-apple-darwin.tar.xz"
      sha256 "e21ba95d4117b9b532f5a2f6d92ce26ed3b783d89d86e10d7decdb7f87b9f66e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nrgforge/zani/releases/download/v0.2.0/zani-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3dff67d42327378c14bff8526694b8e8372c9452389798e72a2a535f12e849e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nrgforge/zani/releases/download/v0.2.0/zani-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c580d5d8fc8be69aa136d829b6fd07d76bfff1f5b18c6e144ee24788b14c75db"
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
