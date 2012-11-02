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
              checkers = NoopChecker:TrueChecker:FalseChecker
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
              checkers = NoopChecker:NoneExistingChecker
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
          | foo.rb  | text   |
          | bar.png | binary |
          | qux     | text   |
     When I run `git-conform --files` in the git repo
     Then the exit status should be 0
     Then the output should contain exactly:
          """
          bar.png
          foo.rb
          qux

          """
