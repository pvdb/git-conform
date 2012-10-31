module Git
  module Conform
    class LowercaseFilenameChecker < FileChecker

      def self.conforms? filename
        super && filename.match(/[A-Z]/).nil?
      end

    end
  end
end
