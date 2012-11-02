module Git
  module Conform
    class LowercaseFilenameChecker < FileChecker

      def conforms?
        super && @filename.match(/[A-Z]/).nil?
      end

    end
  end
end
