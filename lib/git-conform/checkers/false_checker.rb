module Git
  module Conform
    class FalseChecker < FileChecker

      def self.conforms? filename
        super && false
      end

    end
  end
end
