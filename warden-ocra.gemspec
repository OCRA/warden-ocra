# -*- encoding: utf-8 -*-
require File.expand_path('../lib/warden-ocra/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexis Reigel", "Philipp Hoffmann"]
  gem.email         = ["mail@koffeinfrei.org", "phil@branch14.org"]
  gem.description   = %q{Warden strategy for OCRA (rfc6287)}
  gem.summary       = %q{Warden strategy for OCRA (rfc6287)}
  gem.homepage      = "https://github.com/koffeinfrei/warden-ocra"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "warden-ocra"
  gem.require_paths = ["lib"]
  gem.version       = Warden::Ocra::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'sinatra'
  gem.add_development_dependency 'rack-test'

  gem.add_runtime_dependency 'warden'
  gem.add_runtime_dependency 'rocra'
end
