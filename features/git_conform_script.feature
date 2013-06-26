Feature: the git-conform script

  Scenario: a git repo with missing Git::Conform configuration

    Given a git config file named ".gitconform" with:
          """
          """
     When I run `git-conform --list` in the git repo
     Then the exit status should be 0
      And the output should be empty

  Scenario: a git repo with empty Git::Conform configuration

    Given a git config file named ".gitconform" with:
          """
          [git "conform"]
          """
     When I run `git-conform --list` in the git repo
     Then the exit status should be 0
      And the output should be empty

  Scenario: a git repo with valid Git::Conform configuration

    Given a git config file named ".gitconform" with:
          """
          [git "conform"]
              checker = NoopChecker
              checker = TrueChecker
              checker = FalseChecker
          """
     When I run `git-conform --list` in the git repo
     Then the exit status should be 0
      And the output should contain exactly:
          """
          FalseChecker
          NoopChecker
          TrueChecker

          """
     When I run `git-conform --verify` in the git repo
     Then the exit status should be 0

  Scenario: a git repo with invalid Git::Conform configuration

    Given a git config file named ".gitconform" with:
          """
          [git "conform"]
              checker = NoopChecker
              checker = NoneExistingChecker
          """
     When I run `git-conform --list` in the git repo
     Then the exit status should be 0
      And the output should contain exactly:
          """
          NoneExistingChecker
          NoopChecker

          """
     When I run `git-conform --verify` in the git repo
     Then the exit status should be 255
      And the output should match /fatal: uninitialized constant Git::Conform::NoneExistingChecker/

  Scenario: a git repo with a list of files

    Given a git repo with file types:
          | foo.rb     | text   |
          | bar.png    | binary |
          | blegga.tar | binary |
          | qux        | text   |
     When I run `git-conform --files` in the git repo
     Then the exit status should be 0
      And the output should contain all of these:
          | foo.rb     |
          | qux        |
      And the output should not contain any of these:
          | bar.png    |
          | blegga.tar |

  Scenario: a bunch of FileCheckers

     When I run `git-conform --available`
     Then the exit status should be 0
      And the output should not contain any of these:
          | BaseChecker  |
          | FalseChecker |
          | FileChecker  |
          | NoopChecker  |
          | TrueChecker  |
      And the output should contain all of these:
          | CarriageReturnCharacterChecker |
          | FileNotEmptyChecker            |
          | LowercaseFilenameChecker       |
          | NonAsciiCharacterChecker       |
          | NonAsciiFilenameChecker        |
          | TabCharacterChecker            |
          | TrailingWhitespaceChecker      |
          | WhitespaceFilenameChecker      |
