module Git
  module Conform
    class FileChecker < BaseChecker

      @file_exclusion_patterns = []

      class << self

        attr_reader :file_exclusion_patterns

        def excluded? filename
          file_exclusion_patterns.any? { |pattern|
            File.fnmatch?(pattern, filename)
          }
        end

      end

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

      def content
        File.open(@filename, "r") { |file| file.read }
      end

      @@available_checkers = []

      def self.inherited subclass
        # keep track of all defined subclasses
        # for the "--available" command option
        @@available_checkers << subclass
        # ensure all file checkers "inherit" the @file_exclusion_patterns class instance variable
        # http://stackoverflow.com/questions/10728735/inherit-class-level-instance-variables-in-ruby
        subclass.instance_variable_set(:@file_exclusion_patterns, @file_exclusion_patterns.dup)
      end

      def self.available_checkers
        @@available_checkers.map(&:name).map { |class_name|
          class_name.match(/\AGit::Conform::(.*Checker)\Z/)[1]
        }
      end

    end
  end
end
