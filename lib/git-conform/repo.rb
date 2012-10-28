require 'rugged'

class Git::Conform::Repo < Rugged::Repository

  def git_conform_enabled?
    File.exists? File.join(workdir, ".gitconform")
  end

end
