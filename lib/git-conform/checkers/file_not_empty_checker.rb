module Git
  module Conform
    class FileNotEmptyChecker < FileChecker

      def self.conforms? filename
        super && !File.size?(filename).nil?
      end

    end
  end
end
