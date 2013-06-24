module Git
  module Conform
    class LowercaseFilenameChecker < FileChecker

      @file_exclusion_patterns << '*Brewfile*'
      @file_exclusion_patterns << '*Rakefile*'
      @file_exclusion_patterns << '*Gemfile*'
      @file_exclusion_patterns << '*Guardfile*'
      @file_exclusion_patterns << '*Capfile*'
      @file_exclusion_patterns << '*Procfile*'
      @file_exclusion_patterns << '*Vagrantfile*'

      @file_exclusion_patterns << '*README*'

      def conforms?
        super && @filename.match(/[A-Z]/).nil?
      end

    end
  end
end
