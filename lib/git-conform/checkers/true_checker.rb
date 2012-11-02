module Git
  module Conform
    class TrueChecker < FileChecker

      def conforms?
        super && true
      end

    end
  end
end
