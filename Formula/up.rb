require "language/go"

class Up < Formula
  desc "Up ultimate plumber"
  homepage "https://github.com/akavel/up"
  version '0.3'
  url "https://github.com/akavel/up/archive/v#{version}.tar.gz"
  sha256 "286a3341b863a9d2ef3b5c7f91015f5d4a6d8e87d4e074c19ae1553923b1083d"

  head "https://github.com/akavel/up.git"

  depends_on "go" => :build

  bottle do
    root_url "http://nikvdp.com/homebrew-bottles"
    cellar :any_skip_relocation
    sha256 "8087432cd6f88420cc3f01f238275cb5c7403ed329e58a31dba35db50cfa9ee6" => :high_sierra
  end

  def install
    cd buildpath do
      system "go", "get", "-d", "."
      system "go", "build", "-o", "up"

      bin.install "up"
    end
  end

end
