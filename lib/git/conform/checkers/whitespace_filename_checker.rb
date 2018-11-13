module Git
  module Conform
    class WhitespaceFilenameChecker < FileChecker

      def conforms?
        super && @filename.match(/[[:space:]]/).nil?
      end

    end
  end
end
