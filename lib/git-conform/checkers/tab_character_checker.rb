module Git
  module Conform
    class TabCharacterChecker < FileChecker

      def conforms?
        super && !content.include?("\t")
      end

    end
  end
end
