#
# Methadone/Aruba "extensions"/"customizations"
#

Then /^the output should be empty$/ do
  step %(the output should contain exactly:), ""
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
  @repo = Git::Conform::Repo.init_at(File.join(current_dir, repo_path), false)
end

When /^I run `([^\140]*)` in the git repo$/ do |cmd|
  step %(I run `#{cmd}` in "#{@repo_path}" directory)
end

Given /^a git repo in directory "([^\042]*)" with files:$/ do |repo_path, files_table|
  step %(a git repo in directory "#{repo_path}")
  files_table.raw.each do |(file_path)|
    step %(an empty file named "#{File.join(repo_path, file_path)}")
  end
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

#
# Steps that verify the Git::Conform expectations
#

Then /^no conformity checkers apply to the git repo$/ do
  @repo.conformity_checkers.should be_empty
end

Then /^the following conformity checkers apply to the git repo:$/ do |table|
  @repo.conformity_checkers.should =~ table.raw.flatten
end

Then /^the conformity checkers are valid$/ do
  expect { @repo.verify }.to_not raise_error(NameError)
end

Then /^the conformity checkers are invalid$/ do
  expect { @repo.verify }.to raise_error(NameError)
end
