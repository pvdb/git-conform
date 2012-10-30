module Git
  module Conform
    class FileNotEmptyChecker < BaseChecker

      def self.conforms? filename
        !File.size?(filename).nil?
      end

    end
  end
end
