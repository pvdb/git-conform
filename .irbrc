# vim:syntax=ruby

require 'rubygems'
require 'bundler'

Bundler.require
Bundler.require :development

$:.unshift Dir.pwd
$:.unshift File.join(Dir.pwd, 'lib')
require 'git-conform'

def irb_repo
  # irb Git::Conform::Repo.new(Dir.pwd)
  irb Rugged::Repository.new(Dir.pwd)
end

# That's all, Folks!
