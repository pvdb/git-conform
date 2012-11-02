require "bundler/gem_tasks"

require 'cucumber'
require 'cucumber/rake/task'

require 'rspec'
require 'rspec/core/rake_task'

task :gemspec do
  @gemspec ||= eval(File.read(Dir["*.gemspec"].first))
end

desc "Validate the gemspec"
task :validate => :gemspec do
  @gemspec.validate
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--format d --color"
end
task :rspec => [:spec]

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty --tags ~@wip"
end
task :cucumber => [:features]

# the principle of least surprise...
task :default => [:test]
task :test => [:spec, :features]
