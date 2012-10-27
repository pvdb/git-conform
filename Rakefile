require "bundler/gem_tasks"

require 'cucumber'
require 'cucumber/rake/task'

task :gemspec do
  @gemspec ||= eval(File.read(Dir["*.gemspec"].first))
end

desc "Validate the gemspec"
task :validate => :gemspec do
  @gemspec.validate
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty --tags ~@wip"
end

# the principle of least surprise...
task :default => [:features]
task :cucumber => [:features]
task :test => [:features]
