module Git
  module Conform
    class NonAsciiCharacterChecker < FileChecker

      def self.conforms? filename
        super && File.read(filename).ascii_only?
      end

    end
  end
end
