require 'rugged'

class Git::Conform::Repo < Rugged::Repository

  def git_conform_path
    File.join(workdir, ".gitconform")
  end

  def git_conform_enabled?
    File.exists? git_conform_path
  end

end