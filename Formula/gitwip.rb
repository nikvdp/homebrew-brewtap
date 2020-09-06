class Gitwip < Formula

  version "857e0a165e92c0dace653c34003da6623ea73452"
  desc 'Git wip'
  url "https://raw.githubusercontent.com/bartman/git-wip/#{version}/git-wip"
  sha256 "e7d16040b780e16dd401a89cf961105ee07218ad374cfc58b4e8d5834d7d0c6b"
  head "https://github.com/bartman/git-wip"


  def install
    bin.install "git-wip"
  end
end
