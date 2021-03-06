require 'rugged'

module Git
  module Conform
    class Repo < Rugged::Repository

      def repo
        # a bug/feature in Rugged prevents us from using instances of a subclass of Rugged::Repository
        # in certain methods/places; instead it insists on an instance of Rugged::Repository itself...
        # (meaning we can't use `self` on those occasions!) where is Barbara Liskov when you need her?
        @repo ||= Rugged::Repository.new(path)
      end

      def git_conform_path
        repo_path = File.join(workdir, '.gitconform')
        File.exist?(repo_path) ? repo_path : Git::Conform::DEFAULT_PATH
      end

      def git_conform_enabled?
        File.exist? git_conform_path
      end

      def conformity_checkers
        @conformity_checkers ||= begin
                                   # TODO: make this work via Rugged (why doesn't `Rugged::Config.new()` work?!?)
                                   `git config -f #{git_conform_path} --get-all git.conform.checker`.chomp.split($RS)
                                 end
      end

      def binary_patterns
        @binary_patterns ||= begin
                               # TODO: make this work via Rugged (why doesn't `Rugged::Config.new()` work?!?)
                               `git config -f #{git_conform_path} --get-all git.conform.binary`.chomp.split($RS)
                             end
      end

      def exclusion_patterns
        @exclusion_patterns ||= begin
                                  # TODO: make this work via Rugged (why doesn't `Rugged::Config.new()` work?!?)
                                  `git config -f #{git_conform_path} --get-all git.conform.exclusion`.chomp.split($RS)
                                end
      end

      def verify
        conformity_checkers.each do |checker|
          constantize "Git::Conform::#{checker}"
        end
      end

      def files(options = {})
        type = options[:type] || :all
        @files ||= {}
        @files[type] ||= begin
                           files = []
                           repo.lookup(head.target.oid).tree.walk_blobs { |root, entry|
                             entry_path = (root.empty? ? entry[:name] : File.join(root, entry[:name]))
                             files << entry_path if binary?(entry) ? (type != :text) : (type != :binary)
                           }
                           files
                         end
      end

      private

      # http://stackoverflow.com/questions/6119956/how-to-determine-if-git-handles-a-file-as-binary-or-as-text
      # `pcregrep -l '\\x00' #{File.join(self.workdir, path)}` ; $? == 0

      # TODO: is this the most performant way? (see also: "man 5 gitattributes" for inspiration)

      def binary?(entry)
        binary_patterns.any? { |glob_pattern|
          File.fnmatch?(glob_pattern, entry[:name])
        } || !@repo.lookup(entry[:oid]).read_raw.data.match(/\x00/).nil?
      end

    end
  end
end
