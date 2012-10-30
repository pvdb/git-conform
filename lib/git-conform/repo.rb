require 'rugged'

class Git::Conform::Repo < Rugged::Repository

  def repo
    # a bug/feature in Rugged prevents us from using instances of a subclass of Rugged::Repository
    # in certain methods/places; instead it insists on an instance of Rugged::Repository itself...
    # (meaning we can't use `self` on those occasions!) where is Barbara Liskov when you need her?
    @repo ||= Rugged::Repository.new(self.path)
  end

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

  def binary? path
    # TODO make this work via Rugged (see also: man 5 gitattributes for inspiration)
    # http://stackoverflow.com/questions/6119956/how-to-determine-if-git-handles-a-file-as-binary-or-as-text
    `pcregrep -l '\\x00' #{File.join(self.workdir, path)}`
    $? == 0
  end

  def files
    [].tap { |files|
      repo.lookup(self.head.target).tree.walk_blobs { |root, entry|
        path = (root.empty? ? entry[:name] : File.join(root, entry[:name]))
        files << path unless binary? path
      }
    }
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