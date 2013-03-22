require 'bundler/setup'
Bundler.require(:default)

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$:.unshift root

SPEC_PATH    = File.expand_path(File.dirname(__FILE__))
FIXTURE_PATH = "#{SPEC_PATH}/fixtures/**/*.rb"

Dir[FIXTURE_PATH].each{ |fixture| require fixture }