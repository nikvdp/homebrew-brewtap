require "language/go"

class Fzf < Formula
  desc "Fzf fuzzy finder"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.17.3.zip"
  version '0.17.3'
  sha256 "d1f814b9283d95add493545c5f0fe78d461b8b8fa9a9e1da8da62cac061d2916"

  bottle do
    root_url "http://nikvdp.com/homebrew-bottles"
    cellar :any_skip_relocation
  end

  head "https://github.com/junegunn/fzf"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    # path = buildpath/"src/github.com/pocke/lemonade"
    # path.install Dir["*"]
    # Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath do
      system "go", "get", "github.com/junegunn/fzf"
      system "go", "build", "-o", "fzf"

      bin.install "fzf"
    end
  end

end
