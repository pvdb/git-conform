$:.unshift File.realpath File.join(File.dirname(__FILE__), '..', 'lib')

require 'git-conform'

require 'pry'
require 'aruba/api'
