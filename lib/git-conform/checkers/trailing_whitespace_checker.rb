module Git
  module Conform
    class TrailingWhitespaceChecker < FileChecker

      def self.conforms? filename
        super && File.read(filename).match(/[[:blank:]]$/).nil?
      end

    end
  end
end
