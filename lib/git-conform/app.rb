require 'rugged'

class Git::Conform::App

  def initialize working_dir
    @repo = Rugged::Repository.new(Rugged::Repository.discover(working_dir))
  end

  def workdir
    @repo.workdir
  end

  def git_conform_enabled?
    File.exists? File.join(@repo.workdir, ".gitconform")
  end

end
