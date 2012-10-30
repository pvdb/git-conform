module Git
  module Conform
    class BaseChecker

      def self.conforms? filename
        raise "SubclassResponsibility"
      end

    end
  end
end
