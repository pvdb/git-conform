module Git
  module Conform
    class NonAsciiFilenameChecker < FileChecker

      def self.conforms? filename
        super && filename.ascii_only?
      end

    end
  end
end
