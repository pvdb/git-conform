module Git
  module Conform
    class FileNotEmptyChecker < FileChecker

      def conforms?
        super && !File.size?(@filename).nil?
      end

    end
  end
end
