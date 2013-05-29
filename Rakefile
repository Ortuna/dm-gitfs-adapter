require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color --require spec_helper -fp -b --order rand'
  t.rspec_opts << ' --tag ~travis' if ENV['TRAVIS']
end

task :default => :spec
