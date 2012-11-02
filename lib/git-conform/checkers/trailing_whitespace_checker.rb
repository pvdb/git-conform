module Git
  module Conform
    class TrailingWhitespaceChecker < FileChecker

      def conforms?
        super && File.read(@filename).match(/[[:blank:]]$/).nil?
      end

    end
  end
end
