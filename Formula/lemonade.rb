require "language/go"

class Lemonade < Formula
  desc "Lemonade remote utility tool"
  homepage "https://github.com/pocke/lemonade"
  url "https://github.com/progrium/termshare/archive/v0.2.0.tar.gz"
  sha256 "fa09a5492d6176feff32bbcdb3b2dc3ff1b5ab2d1cf37572cc60eb22eb531dcd"
  revision 1

  head "https://github.com/pocke/lemonade.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    # path = buildpath/"src/github.com/pocke/lemonade"
    # path.install Dir["*"]
    # Language::Go.stage_deps resources, buildpath/"src"

    cd path do
      system "go", "get" "https://github.com/pocke/lemonade"
      system "go", "build", "-o", "lemonade"

      bin.install "lemonade"
    end
  end

end
