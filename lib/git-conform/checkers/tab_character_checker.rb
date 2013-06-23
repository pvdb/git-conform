module Git
  module Conform
    class TabCharacterChecker < FileChecker

      @file_exclusion_patterns << '.gitconform'
      # .gitconform is designed to be maintained using the 'git config'
      # command, which uses tab characters for its indentation purposes

      def conforms?
        super && !content.include?("\t")
      end

    end
  end
end
