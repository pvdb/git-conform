module Git
  module Conform
    class TrailingWhitespaceChecker < FileChecker

      def conforms?
        super && content.match(/[[:blank:]]$/).nil?
      end

    end
  end
end
