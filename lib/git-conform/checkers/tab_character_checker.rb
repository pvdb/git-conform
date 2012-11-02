module Git
  module Conform
    class TabCharacterChecker < FileChecker

      def conforms?
        super && !File.read(@filename).include?("\t")
      end

    end
  end
end
