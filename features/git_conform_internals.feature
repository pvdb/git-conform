Feature: the Git::Conform internals

  Scenario: list of files considered by Git::Conform

    Given a git repo with files:
          | foo.rb |
          | bar.rb |
          | qux.rb |
     Then git conform checks "3" files for conformity
      And conformity is checked for files:
          | foo.rb |
          | bar.rb |
          | qux.rb |

  Scenario: a git repo with missing Git::Conform configuration

    Given a git config file named ".gitconform" with:
          """
          """
     Then no conformity checkers apply to the git repo

  Scenario: a git repo with empty Git::Conform configuration

    Given a git config file named ".gitconform" with:
          """
          [git "conform"]
          """
     Then no conformity checkers apply to the git repo

  Scenario: a git repo with valid Git::Conform configuration

    Given a git config file named ".gitconform" with:
          """
          [git "conform"]
              checkers = NoopChecker:TrueChecker:FalseChecker
          """
     Then the following conformity checkers apply to the git repo:
          | NoopChecker  |
          | TrueChecker  |
          | FalseChecker |
      And all conformity checkers are valid

  Scenario: a git repo with invalid Git::Conform configuration

    Given a git config file named ".gitconform" with:
          """
          [git "conform"]
              checkers = NoneExistingChecker:NoopChecker
          """
     Then the following conformity checkers apply to the git repo:
          | NoopChecker         |
          | NoneExistingChecker |
      And at least one conformity checker is invalid
