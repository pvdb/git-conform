# vim:syntax=ruby

require 'rubygems'
require 'bundler'
Bundler.require

$:.unshift Dir.pwd
$:.unshift File.join(Dir.pwd, 'lib')
require 'git-conform'

# That's all, Folks!
