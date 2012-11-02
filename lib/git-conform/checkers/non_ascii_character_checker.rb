module Git
  module Conform
    class NonAsciiCharacterChecker < FileChecker

      def conforms?
        super && File.read(@filename).ascii_only?
      end

    end
  end
end
