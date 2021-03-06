# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dm-gitfs-adapter/version"

Gem::Specification.new do |spec|
  spec.name          = "dm-gitfs-adapter"
  spec.version       = DataMapper::Gitfs::VERSION
  spec.authors       = ["Sumeet Singh"]
  spec.email         = ["ortuna@gmail.com"]
  spec.description   = %q{folder/directory mapper that keeps git history}
  spec.summary       = spec.description
  spec.homepage      = "http://github.com/ortuna/dm-gitfs-adapter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'dm-core', '~>1.2.0'
  spec.add_dependency 'dm-types', '~>1.2.0'
  spec.add_dependency 'grit', '~>2.5.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
