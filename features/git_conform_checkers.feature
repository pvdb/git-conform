Feature: the Git::Conform checkers

  Scenario: Git::Conform::TrueChecker

    Given an empty file named "blegga.rb"
     Then "blegga.rb" "passes" the "TrueChecker" conformity

  Scenario: Git::Conform::FalseChecker

    Given an empty file named "blegga.rb"
     Then "blegga.rb" "fails" the "FalseChecker" conformity
