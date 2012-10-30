module Git
  module Conform
    class FileChecker < BaseChecker

      def self.conforms? filename
        if File.exists? filename
          unless File.file? filename
            raise "Is a directory - #{filename}"
          end
        else
          raise "No such file or directory - #{filename}"
        end
        true
      end

    end
  end
end
