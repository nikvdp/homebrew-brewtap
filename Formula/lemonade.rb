require "language/go"

class Lemonade < Formula
  desc "Lemonade remote utility tool"
  homepage "https://github.com/pocke/lemonade"
  url "https://github.com/pocke/lemonade/archive/v1.1.1.zip"
  version '1.1.1'
  sha256 "d51a78f51bf0504e8c84c91f962859b25ba14e469f2e3dffcf8d7da495667cbb"

  bottle do
    root_url "http://nikvdp.com/homebrew-bottles"
    cellar :any_skip_relocation
    sha256 "7a3eeb19e2afce398ccfaefbd71b61d7fc99644e8228916e2dde12ebfa2cb703" => :el_capitan
  end

  head "https://github.com/pocke/lemonade.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    # path = buildpath/"src/github.com/pocke/lemonade"
    # path.install Dir["*"]
    # Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath do
      system "go", "get", "github.com/pocke/lemonade"
      system "go", "build", "-o", "lemonade"

      bin.install "lemonade"
    end
  end

end