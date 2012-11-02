module Git
  module Conform
    class BaseChecker

      attr_reader :filename

      def initialize filename
        @filename = filename
      end

      def conforms?
        raise "SubclassResponsibility"
      end

      def check_conformity &block
        yield @filename unless conforms?
      end

    end
  end
end