require 'rubygems'

require 'rugged'
require 'trollop'

require 'git-conform/version'
require 'git-conform/banner'
require 'git-conform/copyright'

require 'git-conform/extensions'
require 'git-conform/repo'

# load all conformity checkers found in the 'lib/git-conform/checkers' directory
Dir.glob(File.join(File.dirname(__FILE__), 'git-conform', 'checkers', '*_checker.rb'), &method(:require))

module Git
  module Conform
    # Your code goes here...
  end
end
