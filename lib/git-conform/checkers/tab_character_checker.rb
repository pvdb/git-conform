module Git
  module Conform
    class TabCharacterChecker < FileChecker

      @file_exclusion_patterns << '.gitconform'
      # .gitconform is designed to be maintained using the 'git config'
      # command, which uses tab characters for its indentation purposes

      @file_exclusion_patterns << '.gitmodules'
      # .gitmodules uses a format very similar to the 'git config' one!

      def conforms?
        super && !content.include?("\t")
      end

    end
  end
end
