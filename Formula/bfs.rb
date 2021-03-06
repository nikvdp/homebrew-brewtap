class Bfs < Formula
  bottle do
    root_url "http://srv.nikvdp.com/homebrew-bottles"
    cellar :any_skip_relocation
    sha256 "e6adaa9a12398478ec3400e64696f6f91679f1fcc202083f9454735eceb4f415" => :el_capitan
    sha256 "2ab9e8d124fef5dc94a136a107378d96cc0d9c9bc06f2a72798daac52f58ea5f" => :x86_64_linux
  end

  version '1.1.4'
  desc "Breadth-first version of find."
  homepage "https://github.com/tavianator/bfs"
  url "https://github.com/tavianator/bfs/archive/#{version}.tar.gz"
  sha256 "ce9ebcbc6021d2af12fc639ce8fef8c0dd6ec9aedf0e3a3252f0db91d0ae05ce"
  head "https://github.com/tavianator/bfs.git"

  def install
    system "make", "release"

    bin.install "bfs"

    man1.install "bfs.1"

    pkgshare.install "tests.sh"
    pkgshare.install Dir["tests"]
  end

  test do
    cp_r pkgshare/"tests", testpath
    cp pkgshare/"tests.sh", testpath
    system "./tests.sh", "--bfs=#{bin}/bfs"
  end
end
