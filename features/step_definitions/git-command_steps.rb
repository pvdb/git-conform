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

When /^I run `([^`]*)` in a sub\-directory of a git working dir$/ do |cmd|
  working_dir = "foo/bar/qux_blegga"
  step %(a git repo in directory "#{working_dir}")
  sub_dir = File.join(working_dir, "subdir")
  step %(I run `#{cmd}` in "#{sub_dir}" directory)
end

When /^I run `([^`]*)` in "([^"]*)" directory$/ do |cmd, working_dir|
  step %(a directory named "#{working_dir}")
  cd working_dir
  step %(I run `#{cmd}`)
  @dirs = ['tmp', 'aruba'] # reset Aruba::API.current_dir
end
