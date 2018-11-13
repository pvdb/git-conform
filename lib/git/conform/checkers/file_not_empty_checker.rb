module Git
  module Conform
    class FileNotEmptyChecker < FileChecker

      @file_exclusion_patterns << '*/.gitkeep'
      # .gitkeep is (by convention) an empty file

      def conforms?
        super && !File.size?(@filename).nil?
      end

    end
  end
end
