# -*- ruby -*-

require 'formula'
require 'fileutils'

class RubyGemsDownloadStrategy < AbstractDownloadStrategy
  def fetch
    ohai "Fetching pleaserun from gem source"
    HOMEBREW_CACHE.cd do
      ENV['GEM_SPEC_CACHE'] = "#{HOMEBREW_CACHE}/gem_spec_cache"
      system "gem", "fetch", "pleaserun", "--version", resource.version
    end
  end

  def cached_location
    Pathname.new("#{HOMEBREW_CACHE}/pleaserun-#{resource.version}.gem")
  end

  def clear_cache
    cached_location.unlink if cached_location.exist?
  end
end

class Pleaserun < Formula
  url "pleaserun", :using => RubyGemsDownloadStrategy
  version "0.0.30"
  sha256 "1701322e278547a35191ebc289e0a9127322b962da2f3e5ded0acf7f0ccdf641"
    
  bottle do
    cellar :any_skip_relocation
    root_url "http://srv.nikvdp.com/homebrew-bottles"
    sha256 "3dc772efc7e88b38fb9833bfe49ebdfc061391c64db6ff484ed4b866faf7f5ff" => :high_sierra
    sha256 "118e4ee392e693795a783b7025acd0fb81020139547fd6498a3a5f422c7cd29a" => :x86_64_linux
  end

  def install
    # Copy user's RubyGems config to temporary build home.
    buildpath_gemrc = "#{ENV['HOME']}/.gemrc"
    if File.exists?("#{ENV['HOME']}/.gemrc") && !File.exists?(buildpath_gemrc)
      FileUtils.cp("#{ENV['HOME']}/.gemrc", buildpath_gemrc)
    end

    # set GEM_HOME and GEM_PATH to make sure we package all the dependent gems
    # together without accidently picking up other gems on the gem path since
    # they might not be there if, say, we change to a different rvm gemset
    ENV['GEM_HOME']="#{prefix}"
    ENV['GEM_PATH']="#{prefix}"

    rubybindir = '/usr/bin'
    gem_path = "#{rubybindir}/gem"
    ruby_path = "#{rubybindir}/ruby"
    system gem_path, "install", cached_download,
             "--no-ri",
             "--no-rdoc",
             "--no-wrapper",
             "--no-user-install",
             "--install-dir", prefix,
             "--bindir", bin

    raise "gem install 'pleaserun' failed with status #{$?.exitstatus}" unless $?.success?

    bin.rmtree if bin.exist?
    bin.mkpath

    brew_gem_prefix = prefix+"gems/pleaserun-#{version}"

    completion_for_bash = Dir[
                            "#{brew_gem_prefix}/completion{s,}/pleaserun.{bash,sh}",
                            "#{brew_gem_prefix}/**/pleaserun{_,-}completion{s,}.{bash,sh}"
                          ].first
    bash_completion.install completion_for_bash if completion_for_bash

    completion_for_zsh = Dir[
                           "#{brew_gem_prefix}/completions/pleaserun.zsh",
                           "#{brew_gem_prefix}/**/pleaserun{_,-}completion{s,}.zsh"
                         ].first
    zsh_completion.install completion_for_zsh if completion_for_zsh

    gemspec = Gem::Specification::load("#{prefix}/specifications/pleaserun-#{version}.gemspec")
    ruby_libs = Dir.glob("#{prefix}/gems/*/lib")
    gemspec.executables.each do |exe|
      file = Pathname.new("#{brew_gem_prefix}/#{gemspec.bindir}/#{exe}")
      (bin+file.basename).open('w') do |f|
        f << <<-RUBY
#!#{ruby_path} --disable-gems
ENV['GEM_HOME']="#{prefix}"
ENV['GEM_PATH']="#{prefix}"
require 'rubygems'
$:.unshift(#{ruby_libs.map(&:inspect).join(",")})
load "#{file}"
        RUBY
      end
    end
  end
end
