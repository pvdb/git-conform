module Git
  module Conform
    class LowercaseFilenameChecker < FileChecker

      def self.conforms? filename
        super && filename !~ /[A-Z]/
      end

    end
  end
end
