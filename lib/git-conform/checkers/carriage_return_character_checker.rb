module Git
  module Conform
    class CarriageReturnCharacterChecker < FileChecker

      def conforms?
        super && !File.read(@filename).include?("\r")
      end

    end
  end
end
