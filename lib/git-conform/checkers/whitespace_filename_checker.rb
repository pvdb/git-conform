module Git
  module Conform
    class WhitespaceFilenameChecker < FileChecker

      def self.conforms? filename
        super && filename.match(/[[:space:]]/).nil?
      end

    end
  end
end
