Feature: the Git::Conform checkers

  Scenario: Git::Conform::FileChecker

    Given a file named "blegga.rb" should not exist
     Then the "FileChecker" raises "No such file or directory - tmp/aruba/blegga.rb" for "blegga.rb"

    Given a directory named "blegga"
     Then the "FileChecker" raises "Is a directory - tmp/aruba/blegga" for "blegga"

    Given an empty file named "blegga.rb"
     Then the "FileChecker" raises nothing for "blegga.rb"

    Given a non-empty file named "blegga.rb"
     Then the "FileChecker" raises nothing for "blegga.rb"

  Scenario: Git::Conform::TrueChecker

    Given an empty file named "blegga.rb"
     Then "blegga.rb" "passes" the "TrueChecker" conformity

  Scenario: Git::Conform::FalseChecker

    Given an empty file named "blegga.rb"
     Then "blegga.rb" "fails" the "FalseChecker" conformity

  Scenario: Git::Conform::FileNotEmptyChecker

    Given a non-empty file named "blegga.rb"
     Then "blegga.rb" "passes" the "FileNotEmptyChecker" conformity

    Given an empty file named "blegga.rb"
     Then "blegga.rb" "fails" the "FileNotEmptyChecker" conformity

  Scenario: Git::Conform::LowercaseFilenameChecker

    Given a non-empty file named "foo_bar_blegga.rb"
     Then "foo_bar_blegga.rb" "passes" the "LowercaseFilenameChecker" conformity

    Given an empty file named "FooBarBlegga.rb"
     Then "FooBarBlegga.rb" "fails" the "LowercaseFilenameChecker" conformity
