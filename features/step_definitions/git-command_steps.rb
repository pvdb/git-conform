#
# Methadone/Aruba "extensions"/"customizations"
#

When /^I get the version of "([^"]*)"$/ do |script_name|
  @script_name = script_name
  step %(I run `#{script_name} --version`)
end

Then /^the output should include the version$/ do
  step %(the output should match /v\\d+\\.\\d+\\.\\d+/)
end

Then /^the output should include the app name$/ do
  step %(the output should match /#{Regexp.escape(@script_name)}/)
end

Then /^the output should include a copyright notice$/ do
  step %(the output should match /Copyright \\(c\\) [\\d]{4} [[\\w]+]+/)
end

#
# Steps that interact with `git` (via `rugged`)
#

Given /^a git repo in directory "([^"]*)"$/ do |project_name|
  @pwd = File.join(current_dir, project_name)
  @repo = Rugged::Repository.init_at(@pwd, false)
end

Given /^a git repo in directory "([^"]*)" with files:$/ do |project_name, files_table|
  step %(a git repo in directory "#{project_name}")
  files_table.raw.each do |(file_path)|
    step %(an empty file named "#{File.join(project_name, file_path)}")
  end
end

#
# Steps that interact with `Dir.pwd`
#

When /^I run `([^`]*)` in a non-git working dir$/ do |cmd|
  working_dir = "foo/bar/qux_blegga"
  @dirs = [Dir.tmpdir] # sets Aruba::API.current_dir
  step %(I run `#{cmd}` in "#{working_dir}" directory)
end

When /^I run `([^`]*)` in a git working dir$/ do |cmd|
  working_dir = "foo/bar/qux_blegga"
  step %(a git repo in directory "#{working_dir}")
  step %(I run `#{cmd}` in "#{working_dir}" directory)
end

When /^I run `([^`]*)` in a git working dir with files:$/ do |cmd, files_table|
  working_dir = "foo/bar/qux_blegga"
  step %(a git repo in directory "#{working_dir}" with files:), files_table
  step %(I run `#{cmd}` in "#{working_dir}" directory)
end

When /^I run `([^`]*)` in a git working dir without ".gitconform"$/ do |cmd|
  step %(I run `#{cmd}` in a git working dir)
end

When /^I run `([^`]*)` in a git working dir with ".gitconform"$/ do |cmd|
  step %(I run `#{cmd}` in a git working dir with files:), Cucumber::Ast::Table.parse("| .gitconform |", nil, nil)
end

When /^I run `([^`]*)` in a sub\-directory of a git working dir with ".gitconform"$/ do |cmd|
  working_dir = "foo/bar/qux_blegga"
  step %(a git repo in directory "#{working_dir}" with files:), Cucumber::Ast::Table.parse("| .gitconform |", nil, nil)
  sub_dir = File.join(working_dir, "subdir")
  step %(I run `#{cmd}` in "#{sub_dir}" directory)
end

When /^I run `([^`]*)` in "([^"]*)" directory$/ do |cmd, working_dir|
  step %(a directory named "#{working_dir}")
  cd working_dir
  step %(I run `#{cmd}`)
  @dirs = ['tmp', 'aruba'] # reset Aruba::API.current_dir
end
