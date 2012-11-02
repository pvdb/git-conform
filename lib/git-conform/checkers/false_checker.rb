module Git
  module Conform
    class FalseChecker < FileChecker

      def conforms?
        super && false
      end

    end
  end
end
