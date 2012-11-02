module Git
  module Conform
    class BaseChecker

      attr_reader :filename

      def initialize filename
        @filename = filename
      end

      def self.conforms? filename
        raise "SubclassResponsibility"
      end

    end
  end
end
