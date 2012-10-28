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

  def verify
    conformity_checkers.each do |checker|
      constantize "Git::Conform::#{checker}"
    end
  end

  private

  # http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-constantize
  def constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end

end