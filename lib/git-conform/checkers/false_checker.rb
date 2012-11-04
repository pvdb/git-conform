module Git
  module Conform
    class FalseChecker < BaseChecker

      def conforms?
        false
      end

    end
  end
end
