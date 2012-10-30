Feature: the Git::Conform checkers

  Scenario: Git::Conform::TrueChecker

    Given an empty file named "blegga.rb"
     Then "blegga.rb" "passes" the "TrueChecker" conformity

  Scenario: Git::Conform::FalseChecker

    Given an empty file named "blegga.rb"
     Then "blegga.rb" "fails" the "FalseChecker" conformity

  Scenario: Git::Conform::FileNotEmptyChecker

    Given a 1 byte file named "blegga.rb"
     Then "blegga.rb" "passes" the "FileNotEmptyChecker" conformity

    Given an empty file named "blegga.rb"
     Then "blegga.rb" "fails" the "FileNotEmptyChecker" conformity
