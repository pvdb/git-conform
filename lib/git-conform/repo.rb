require 'rugged'

class Git::Conform::Repo < Rugged::Repository

  def git_conform_path
    File.join(workdir, ".gitconform")
  end

  def git_conform_enabled?
    File.exists? git_conform_path
  end

  def conformity_checkers
    @conformity_checkers ||= begin
      # TODO make this work via Rugged (why doesn't `Rugged::Config.new()` work?!?)
      `git config -f #{git_conform_path} git.conform.checkers`.chomp.split(':')
    end
  end

end