module Git
  module Conform
    class TrueChecker < BaseChecker

      def self.conforms? filename
        true
      end

    end
  end
end
