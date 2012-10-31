module Git
  module Conform
    class TabCharacterChecker < FileChecker

      def self.conforms? filename
        super && !File.read(filename).include?("\t")
      end

    end
  end
end
