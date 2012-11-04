#
# Methadone/Aruba "extensions"/"customizations"
#

Given /^a non\-empty file named "([^\042]*)"$/ do |file_name|
  step %(a 1 byte file named "#{file_name}")
end

Given /^a file named "([^\042]*)" with content "([^\042]*)"$/ do |file_name, content|
  step %(a file named "#{file_name}" with:), content.gsub(/\\[nrt]/) { |match|
    case match
      when '\n' then "\n"
      when '\r' then "\r"
      when '\t' then "\t"
    end
  }
end

Then /^the output should be empty$/ do
  all_output.should be_empty
end

Then /^the output should not be empty$/ do
  all_output.should_not be_empty
end

When /^I get the version of "([^\042]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} --version`)
end

Then /^the output should include the version$/ do
  step %(the output should match /v\\d+\\.\\d+\\.\\d+/)
end

Then /^the output should include the app name$/ do
  step %(the output should match /#{Regexp.escape(@app_name)}/)
end

Then /^the output should include a copyright notice$/ do
  step %(the output should match /Copyright \\(c\\) [\\d]{4} [[\\w]+]+/)
end

When /^I run `([^\140]*)` in "([^\042]*)" directory$/ do |cmd, working_dir|
  step %(a directory named "#{working_dir}")
  cd working_dir
  step %(I run `#{cmd}`)
  @dirs = ['tmp', 'aruba'] # reset Aruba::API.current_dir
end

#
# Steps that interact with `git` (via `rugged`)
#

Given /^a git repo in directory "([^\042]*)"$/ do |repo_path|
  @repo_path = repo_path
  aruba_path = File.join(current_dir, repo_path)
  @repo = if File.exists?(File.join(aruba_path, ".git"))
    Git::Conform::Repo.new(aruba_path)
  else
    Git::Conform::Repo.init_at(aruba_path, false)
  end
end

When /^I run `([^\140]*)` in the git repo$/ do |cmd|
  step %(I run `#{cmd}` in "#{@repo_path}" directory)
end

Given /^a git repo in directory "([^\042]*)" with files:$/ do |repo_path, files_table|
  step %(a git repo in directory "#{repo_path}")
  # TODO make the below work via `rugged`
  files_table.raw.each do |(file_path)|
    step %(an empty file named "#{File.join(repo_path, file_path)}")
    # step %(I run `git add #{file_path}` in "#{repo_path}" directory)
    `cd #{File.join(current_dir ,repo_path)} && git add #{file_path}`
  end
  # step %(I run `git commit -m 'adding files'` in "#{repo_path}" directory)
  `cd #{File.join(current_dir ,repo_path)} && git commit -m 'adding files'`
end

Given /^a git repo in directory "([^\042]*)" with file types:$/ do |repo_path, file_types_table|
  step %(a git repo in directory "#{repo_path}")
  # TODO make the below work via `rugged`
  file_types_table.raw.each do |(file_path, file_type)|
    case file_type
    when 'text' then step %(an empty file named "#{File.join(repo_path, file_path)}")
    when 'binary' then step %(a file named "#{File.join(repo_path, file_path)}" with:), "\000"
    end
    # step %(I run `git add #{file_path}` in "#{repo_path}" directory)
    `cd #{File.join(current_dir ,repo_path)} && git add #{file_path}`
  end
  # step %(I run `git commit -m 'adding files'` in "#{repo_path}" directory)
  `cd #{File.join(current_dir ,repo_path)} && git commit -m 'adding files'`
end

#
# Steps that set up a git repo before running a cmd
#

AD_HOC_REPO_PATH = "foo/bar/qux_blegga".freeze

When /^I run `([^\140]*)` in a non-git working dir$/ do |cmd|
  @dirs = [Dir.tmpdir] # sets Aruba::API.current_dir
  step %(I run `#{cmd}` in "#{AD_HOC_REPO_PATH}" directory)
end

When /^I run `([^\140]*)` in a git working dir$/ do |cmd|
  step %(a git repo in directory "#{AD_HOC_REPO_PATH}")
  step %(I run `#{cmd}` in "#{AD_HOC_REPO_PATH}" directory)
end

When /^I run `([^\140]*)` in a git working dir with files:$/ do |cmd, files_table|
  step %(a git repo in directory "#{AD_HOC_REPO_PATH}" with files:), files_table
  step %(I run `#{cmd}` in "#{AD_HOC_REPO_PATH}" directory)
end

When /^I run `([^\140]*)` in a git working dir without ".gitconform"$/ do |cmd|
  step %(I run `#{cmd}` in a git working dir)
end

When /^I run `([^\140]*)` in a git working dir with ".gitconform"$/ do |cmd|
  step %(I run `#{cmd}` in a git working dir with files:), Cucumber::Ast::Table.parse("| .gitconform |", nil, nil)
end

When /^I run `([^\140]*)` in a sub\-directory of a git working dir with ".gitconform"$/ do |cmd|
  step %(a git repo in directory "#{AD_HOC_REPO_PATH}" with files:), Cucumber::Ast::Table.parse("| .gitconform |", nil, nil)
  sub_directory = File.join(AD_HOC_REPO_PATH, "sub_directory")
  step %(I run `#{cmd}` in "#{sub_directory}" directory)
end

#
# Steps that configure Git::Conform before running a cmd
#

Given /^a git config file named "([^\042]*)" with:$/ do |file_name, file_content|
  step %(a git repo in directory "#{AD_HOC_REPO_PATH}")
  step %(a file named "#{File.join(@repo.workdir, file_name)}" with:), file_content
end

Given /^a git repo with files:$/ do |files_table|
  step %(a git repo in directory "#{AD_HOC_REPO_PATH}" with files:), files_table
end

Given /^a git repo with file types:$/ do |file_types_table|
  step %(a git repo in directory "#{AD_HOC_REPO_PATH}" with file types:), file_types_table
end

#
# Steps that verify the Git::Conform expectations
#

Then /^git conform checks "(\d+)" files? for conformity$/ do |file_count|
  @repo.files.count.should be file_count.to_i
end

Then /^the following are considered "(text|binary)" files:$/ do |text_or_binary, table|
  @repo.files(:type => text_or_binary.to_sym).should =~ table.raw.flatten
end

Then /^no conformity checkers apply to the git repo$/ do
  @repo.conformity_checkers.should be_empty
end

Then /^the following conformity checkers apply to the git repo:$/ do |table|
  @repo.conformity_checkers.should =~ table.raw.flatten
end

Then /^all conformity checkers are valid$/ do
  expect { @repo.verify }.to_not raise_error(NameError)
end

Then /^at least one conformity checker is invalid$/ do
  expect { @repo.verify }.to raise_error(NameError)
end

#
# Steps that verify the Git::Conform::Checker expectations
#

Then /^the "([^\042]*)" raises "([^\042]*)" for "([^\042]*)"$/ do |checker_class, exception_message, file_name|
  checker_class = constantize "Git::Conform::#{checker_class}"
  expect {
    checker_class.new(File.join(current_dir, file_name)).conforms?
  }.to raise_error(RuntimeError, exception_message)
end

Then /^the "([^\042]*)" raises nothing for "([^\042]*)"$/ do |checker_class, file_name|
  checker_class = constantize "Git::Conform::#{checker_class}"
  expect {
    checker_class.new(File.join(current_dir, file_name)).conforms?
  }.to_not raise_error(RuntimeError)
end

Then /^"([^\042]*)" "(passes|fails)" the "([^\042]*)" conformity$/ do |file_name, passes_or_fails, checker_class|
  checker_class = constantize "Git::Conform::#{checker_class}"
  checker_class.new(File.join(current_dir, file_name)).conforms?.should case
    when passes_or_fails == "passes" then be_true
    when passes_or_fails == "fails" then be_false
  end
end
