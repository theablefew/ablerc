# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ablerc/version'

Gem::Specification.new do |gem|
  gem.name          = "ablerc"
  gem.version       = Ablerc::VERSION
  gem.authors       = ["Spencer Markowski"]
  gem.email         = ["spencer@theablefew.com"]
  gem.description   = %q{Provides cascading configuration files and helpers for generating configuration stubs.}
  gem.summary       = %q{Quickly add "rc" capabilities into your ruby applications.}
  gem.homepage      = "http://github.com/theablefew/ablerc"

  gem.add_dependency "hashie"
  gem.add_dependency "rainbow"
  gem.add_dependency "activesupport"
  #gem.add_development_dependency ""


  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
