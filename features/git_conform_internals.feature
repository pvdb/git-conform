Feature: the Git::Conform internals

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
              checkers = Noop:True:False
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
              checkers = NoneExisting:Noop
          """
     Then the following conformity checkers apply to the git repo:
          | NoopChecker         |
          | NoneExistingChecker |
      And at least one conformity checker is invalid
