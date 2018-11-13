module Git
  module Conform
    class BaseChecker

      attr_reader :filename

      def initialize(filename)
        @filename = filename
        raise "No such file - #{@filename}" unless File.exist? @filename
        raise "Is a directory - #{@filename}" if File.directory? @filename
      end

      def excluded?
        raise 'SubclassResponsibility'
      end

      def conforms?
        raise 'SubclassResponsibility'
      end

      def check_exclusion
        yield @filename if excluded?
      end

      def check_conformity
        yield @filename unless excluded? || conforms?
      end

    end
  end
end
