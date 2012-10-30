module Git
  module Conform
    class TrueChecker < FileChecker

      def self.conforms? filename
        super && true
      end

    end
  end
end
