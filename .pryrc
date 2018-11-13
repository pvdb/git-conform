# this loads all of "git-conform"
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git/conform'

# utility function to set pry context
# to an instance of <Rugged::Repository>
def repository
  pry Rugged::Repository.new(Dir.pwd)
end
