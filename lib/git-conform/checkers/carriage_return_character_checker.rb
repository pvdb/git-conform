module Git
  module Conform
    class CarriageReturnCharacterChecker < FileChecker

      def conforms?
        super && !content.include?("\r")
      end

    end
  end
end
