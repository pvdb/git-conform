#
# Shamelessly copied from rspec-expectations:
#
# https://github.com/rspec/rspec-expectations/blob/master/features/step_definitions/additional_cli_steps.rb
#

# Useful for when the output is slightly different on different versions of ruby
Then /^the output should contain "([^"]*)" or "([^"]*)"$/ do |string1, string2|
  unless [string1, string2].any? { |s| all_output =~ regexp(s) }
    fail %Q{Neither "#{string1}" or "#{string2}" were found in:\n#{all_output}}
  end
end

Then /^the output should contain all of these:$/ do |table|
  table.raw.flatten.each do |string|
    assert_partial_output(string, all_output)
  end
end

Then /^the output should not contain any of these:$/ do |table|
  table.raw.flatten.each do |string|
    assert_no_partial_output(string, all_output)
  end
end

Then /^the following Trollop-style options should be documented:$/ do |options|
  # https://github.com/davetron5000/methadone/issues/37
  options.raw.flatten.each do |option|
    step %(the output should match /\\s*#{Regexp.escape(option)}[\\s\\W]+\\w[\\s\\w][\\s\\w]+/)
  end
end

