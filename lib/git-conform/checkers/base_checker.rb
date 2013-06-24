module Git
  module Conform
    class BaseChecker

      attr_reader :filename

      def initialize filename
        @filename = filename
      end

      def excluded?
        raise "SubclassResponsibility"
      end

      def conforms?
        raise "SubclassResponsibility"
      end

      def check_conformity &block
        yield @filename unless excluded? || conforms?
      end

    end
  end
end
