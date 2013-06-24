module Git
  module Conform
    class BaseChecker

      attr_reader :filename

      def initialize filename
        @filename = filename
        if File.exists? @filename
          unless File.file? @filename
            raise "Is a directory - #{@filename}"
          end
        else
          raise "No such file or directory - #{@filename}"
        end
      end

      def excluded?
        raise "SubclassResponsibility"
      end

      def conforms?
        raise "SubclassResponsibility"
      end

      def check_exclusion &block
        yield @filename if excluded?
      end

      def check_conformity &block
        yield @filename unless excluded? || conforms?
      end

    end
  end
end
