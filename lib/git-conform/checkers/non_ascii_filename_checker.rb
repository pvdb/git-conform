module Git
  module Conform
    class NonAsciiFilenameChecker < FileChecker

      def conforms?
        super && @filename.ascii_only?
      end

    end
  end
end
