require 'rugged'

class Git::Conform::App

  def initialize working_dir

    @git_repo = Rugged::Repository.new(working_dir)

  end

end
