module Git
  module Conform
    class FileChecker < BaseChecker

      def conforms?
        if File.exists? @filename
          unless File.file? @filename
            raise "Is a directory - #{@filename}"
          end
        else
          raise "No such file or directory - #{@filename}"
        end
        true
      end

      @@available_checkers = []

      def self.inherited subclass
        @@available_checkers << subclass
      end

      def self.available_checkers
        @@available_checkers.map(&:name).map { |class_name|
          class_name.match(/Git::Conform::(.*)Checker/)[1]
        }
      end

    end
  end
end
