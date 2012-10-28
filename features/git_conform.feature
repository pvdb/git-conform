Feature: Main Git::Conform Behaviour

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
     When I run `git-conform --list` in the git repo
     Then the following conformity checkers apply to the git repo:
          | NoopChecker  |
          | TrueChecker  |
          | FalseChecker |
      And the output should contain exactly:
          """
          FalseChecker
          NoopChecker
          TrueChecker

          """
