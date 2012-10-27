require 'rugged'

class Git::Conform::App

  def initialize working_dir

    @git_repo = Rugged::Repository.new(Rugged::Repository.discover(working_dir))

  end

end
