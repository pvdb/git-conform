require 'rugged'
require 'English'

require 'ext/string'
require 'ext/inflections'

module Git
  module Conform
    DEFAULT_PATH = File.expand_path('../../.gitconform', __dir__)
  end
end

require 'git/conform/version'
require 'git/conform/repo'

# load the "base" conformity checkers first
require 'git/conform/checkers/base_checker.rb'
require 'git/conform/checkers/file_checker.rb'

# load all other checkers in 'lib/git/conform/checkers'
Dir.glob(
  File.join(__dir__, 'conform', 'checkers', '*_checker.rb'),
  &method(:require)
)
