module Git
  module Conform
    class FalseChecker < BaseChecker

      def self.conforms? filename
        false
      end

    end
  end
end
