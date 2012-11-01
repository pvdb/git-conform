Feature: the Git::Conform binary algorithm

  Scenario: list of files considered by Git::Conform

    Given a git repo with files:
          | foo.rb     |
          | lib/bar.rb |
          | bin/qux.rb |
     Then git conform checks "3" files for conformity
      And conformity is checked for files:
          | foo.rb |
          | lib/bar.rb |
          | bin/qux.rb |

  Scenario: Git::Conform doesn't consider binary files

    Given a git repo with file types:
          | foo.rb  | text   |
          | bar.png | binary |
          | qux.tar | binary |
          | baz.rb  | binary |
     Then git conform checks "1" file for conformity
      And conformity is checked for files:
          | foo.rb |

  Scenario: the .gitconform config file can preempt binary file check

    Given a git repo with file types:
          | foo.rb     | text |
          | lib/bar.rb | text |
          | bin/qux.rb | text |
          | qux.java   | text |
          | baz.py     | text |
      And a git config file named ".gitconform" with:
          """
          [git "conform"]
              binary = *.rb:*.java
          """
     Then git conform checks "1" files for conformity
      And conformity is checked for files:
          | baz.py |
