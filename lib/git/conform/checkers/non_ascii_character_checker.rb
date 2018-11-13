module Git
  module Conform
    class NonAsciiCharacterChecker < FileChecker

      def conforms?
        super && content.ascii_only?
      end

    end
  end
end
