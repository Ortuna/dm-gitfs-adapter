require 'bundler/setup'
Bundler.require(:default, :runtime, :test)

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$:.unshift root