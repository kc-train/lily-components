# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lily-components/version'

Gem::Specification.new do |spec|
  spec.name          = "lily-components"
  spec.version       = LilyComponents::VERSION
  spec.authors       = ["ben7th"]
  spec.email         = ["ben7th@sina.com"]
  spec.summary       = "mindpin lily components"
  spec.homepage      = "https://github.com/kc-train/lily-components"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
