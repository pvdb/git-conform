module Git
  module Conform
    class CarriageReturnCharacterChecker < FileChecker

      def self.conforms? filename
        super && !File.read(filename).include?("\r")
      end

    end
  end
end
