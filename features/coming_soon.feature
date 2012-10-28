Feature: Move Along, Nothing To See Here

  Scenario: run the main script in a directory that is not a git working dir

    When I run `git-conform` in a non-git working dir
    Then the exit status should be 255
     And the output should match /fatal: Not a git repository \(or any of the parent directories\): .*/

  Scenario: run the main script in a directory that is a git working dir not configured for "git conform"

    When I run `git-conform` in a git working dir without ".gitconform"
    Then the exit status should be 255
     And the output should match /fatal: unable to read config file .*: No such file or directory/

  Scenario: run the main script in a directory that is a git working dir configured for "git conform"

    When I run `git-conform` in a git working dir with ".gitconform"
    Then the exit status should be 1
     And the output should match /Coming soon! \(RuntimeError\)/

  Scenario: run the main script in a sub-directory of a git working dir configured for "git conform"

    When I run `git-conform` in a sub-directory of a git working dir with ".gitconform"
    Then the exit status should be 1
     And the output should match /Coming soon! \(RuntimeError\)/

