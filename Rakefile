require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color --require spec_helper -fp -b --order rand --tag ~remote'
end

RSpec::Core::RakeTask.new("spec:remote") do |t|
  t.rspec_opts = '--color --require spec_helper -fp -b --order rand --tag remote'
end

RSpec::Core::RakeTask.new("spec:all") do |t|
  t.rspec_opts = '--color --require spec_helper -fp -b --order rand'
end

task :default => :spec