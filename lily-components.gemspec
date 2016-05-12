# coding: utf-8
require File.expand_path('../lib/lily-components/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "lily-components"
  s.version     = LilyComponents::VERSION
  s.platform       = Gem::Platform::RUBY
  s.authors     = ["ben7th"]
  s.email       = ["ben7th@sina.com"]
  s.homepage    = "https://github.com/kc-train/lily-components"
  s.summary     = "mindpin lily components"
  s.description = "This gem provides components for mindpin team's projects."
  s.license     = "MIT"

  s.required_ruby_version     = ">= 1.9.3"
  s.required_rubygems_version = ">= 1.3.6"

  s.files         = `git ls-files`.split("\n")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end
